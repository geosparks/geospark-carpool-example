package com.geospark.carpooling.ui;

import android.os.Bundle;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import com.geospark.carpooling.R;

public class LiveTrackingActivity extends AppCompatActivity {

    private WebView mWebView;
    private RelativeLayout mProgressBar;
    private String mURL;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_live_tracking);
        mURL = getIntent().getStringExtra("URL");
        mWebView = findViewById(R.id.web_view);
        mProgressBar = findViewById(R.id.progress_bar);
        ImageView imgRefresh = findViewById(R.id.img_refresh);
        ImageView imgBack = findViewById(R.id.img_back);
        imgBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });
        imgRefresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                loadUrl();
            }
        });
        loadUrl();
    }

    private void loadUrl() {
        mWebView.requestFocus();
        mWebView.getSettings().setLightTouchEnabled(true);
        mWebView.getSettings().setJavaScriptEnabled(true);
        mWebView.loadUrl(mURL);
        mWebView.setWebChromeClient(new WebChromeClient() {
            public void onProgressChanged(WebView view, int progress) {
                if (progress < 100) {
                    mProgressBar.setVisibility(View.VISIBLE);
                }
                if (progress >= 100) {
                    mProgressBar.setVisibility(View.GONE);
                }
            }
        });
    }
}
