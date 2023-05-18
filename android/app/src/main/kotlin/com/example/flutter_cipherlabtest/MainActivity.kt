package com.example.flutter_cipherlabtest

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.BroadcastReceiver
import android.os.IBinder
import android.os.RemoteException
import android.widget.Toast
import com.cipherlab.barcode.GeneralString
import com.cipherlab.barcode.ReaderManager
import com.cipherlab.barcodebase.ReaderCallback
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity(), ReaderCallback {

    private var filter: IntentFilter? = null
    private var mReaderManager: ReaderManager? = null
    private var mReaderCallback: ReaderCallback? = null

    private val CHANNEL = "samples.flutter.dev/getscancode"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        mReaderManager = ReaderManager.InitInstance(this)
        mReaderCallback = this

        val channel = EventChannel(flutterEngine.dartExecutor, CHANNEL)
        channel.setStreamHandler(

            object : EventChannel.StreamHandler {

                val receiver = DataReceiver()

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

                    receiver.setListener(object : BroadcastReceiverHandlerListener() {
                        override fun onScanCode(data: String?) {
                            events?.success(data)
                        }
                    })

                    filter = IntentFilter()
                    filter!!.addAction(GeneralString.Intent_PASS_TO_APP)
                    registerReceiver(receiver, filter)

                }

                override fun onCancel(arguments: Any?) {

                }

            }
        )

    }

    class DataReceiver: BroadcastReceiver() {

        private lateinit var callback: BroadcastReceiverHandlerListener

        fun setListener(callback: BroadcastReceiverHandlerListener) {
            this.callback = callback
        }

        override fun onReceive(context: Context, intent: Intent) {

            if (intent.action == GeneralString.Intent_PASS_TO_APP) {

                val data = intent.getStringExtra(GeneralString.BcReaderData)
                callback.onScanCode(data)

            }
        }
    }

    override fun asBinder(): IBinder? {
        // TODO Auto-generated method stub
        return null
    }
    //
    @Throws(RemoteException::class)
    override fun onDecodeComplete(arg0: String) {
        // TODO Auto-generated method stub
        Toast.makeText(this, "Decode Data $arg0", Toast.LENGTH_SHORT).show()
    }

}

abstract class BroadcastReceiverHandlerListener {
    abstract fun onScanCode(data: String?)
}