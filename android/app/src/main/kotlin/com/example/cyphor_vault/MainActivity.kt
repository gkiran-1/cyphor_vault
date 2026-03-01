package com.example.cyphor_vault

import android.os.Build
// Removed OnBackInvokedCallback and OnBackInvokedDispatcher imports for compatibility
import androidx.activity.OnBackPressedCallback
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onResume() {
        super.onResume()
        // Use OnBackPressedDispatcher for all API levels for compatibility
        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                this@MainActivity.moveTaskToBack(true)
            }
        })
    }
}
