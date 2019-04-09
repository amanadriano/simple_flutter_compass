package com.palawenos.simple_flutter_compass

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class SimpleFlutterCompassPlugin: MethodCallHandler {

  companion object {
    lateinit var mRegistrar : Registrar;
    lateinit var mChannel : EventChannel;
    lateinit var mSensorManager : SensorManager;

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      mRegistrar = registrar;

      val channel = MethodChannel(registrar.messenger(), "com.palawenos.simple_flutter_compas.method")
      channel.setMethodCallHandler(SimpleFlutterCompassPlugin())

      mSensorManager = registrar.activeContext().getSystemService(Context.SENSOR_SERVICE) as SensorManager;
      val sensorListener = SensorListener(mSensorManager);
      mChannel = EventChannel(registrar.view(), "com.palawenos.simple_flutter_compas.event")
      mChannel.setStreamHandler(sensorListener);

    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "getPlatformVersion"->
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "check" -> {
        val success = this.init();
        result.success(success);
      }
      "start" -> result.success("start")
      "stop" -> result.success("stop")
      else -> result.notImplemented()
    }
  }

  private fun init(): Boolean {

    //check if device has the hardware
    mSensorManager = mRegistrar.activeContext().getSystemService(Context.SENSOR_SERVICE) as SensorManager
    if (mSensorManager == null) {
      print("No sensor present");
      return false;
    };

    if (mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD) != null) {
      print("has sensor present")
      return true
    } else {
      print("No sensor present")
      return false;
    }
  }

  class SensorListener(private val sensorManager : SensorManager) : EventChannel.StreamHandler, SensorEventListener {

    private val lastAccelerometer = floatArrayOf(0f, 0f, 0f);
    private val lastMagnetometer = floatArrayOf(0f, 0f, 0f);
    private var lastAccelerometerSet = false;
    private var lastMagnetometerSet = false;
    private val mR = FloatArray(9)
    private val mOrientation = floatArrayOf(0f, 0f, 0f)
    private var mCurrentDegree = 0f

    private lateinit var mAccelerometer : Sensor
    private lateinit var mMagnetometer : Sensor

    init {
      mAccelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
      mMagnetometer = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)
    }

    private var eventSink : EventChannel.EventSink? = null;

    override fun onCancel(p0: Any?) {
      unregisterInactive();
      eventSink = null;
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
      if (accuracy == SensorManager.SENSOR_STATUS_ACCURACY_LOW) {
        eventSink?.error("SENSOR", "Low accuracy detected", null);
      }
    }

    override fun onSensorChanged(event: SensorEvent) {
      if (event.sensor == mAccelerometer) {
        System.arraycopy(event.values, 0, lastAccelerometer, 0, event.values.size);
        lastAccelerometerSet = true;
      } else if (event.sensor == mMagnetometer) {
        System.arraycopy(event.values, 0, lastMagnetometer, 0, event.values.size);
        lastMagnetometerSet = true;
      }
      if (lastAccelerometerSet && lastMagnetometerSet) {
        SensorManager.getRotationMatrix(mR, null, lastAccelerometer, lastMagnetometer);
        SensorManager.getOrientation(mR, mOrientation);
        val azimuthInRadians = mOrientation[0];
        val azimuthInDegress = (Math.toDegrees(azimuthInRadians.toDouble()).toFloat() + 360) % 360;

        mCurrentDegree = -azimuthInDegress;
      }

      eventSink?.success(mCurrentDegree);
    }

    override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
      this.eventSink = p1;
      registerActive();
    }

    private fun registerActive() {
      if (eventSink == null) return;
      sensorManager.registerListener(
              this,
              mAccelerometer,
              SensorManager.SENSOR_DELAY_NORMAL
      )
      sensorManager.registerListener(
              this,
              mMagnetometer,
              SensorManager.SENSOR_DELAY_NORMAL
      )
    }

    private fun unregisterInactive() {
      if (eventSink == null) return;
      sensorManager.unregisterListener(this, mAccelerometer);
      sensorManager.unregisterListener(this, mMagnetometer);
    }

  }

}
