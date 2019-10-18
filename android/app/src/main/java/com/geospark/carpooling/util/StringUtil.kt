package com.geospark.carpooling.util

import android.content.Context
import android.text.Spannable
import android.text.SpannableString
import android.text.style.ForegroundColorSpan
import android.text.style.RelativeSizeSpan
import androidx.core.content.ContextCompat
import com.geospark.carpooling.R


fun Context.multiColorText(text: String, start: Int): Spannable {
    val word = SpannableString(text)
    word.setSpan(
        ForegroundColorSpan(ContextCompat.getColor(this, R.color.colorBlack)),
        start, word.length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
    )
    return word
}

fun Context.multiSizeText(text: String, start: Int): Spannable {
    val word = SpannableString(text)
    word.setSpan(RelativeSizeSpan(0.7f), start, text.length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    word.setSpan(
        ForegroundColorSpan(ContextCompat.getColor(this, R.color.colorAccent)),
        start, word.length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
    )
    return word
}


fun Context.multiSizeTextItem(text: String, start: Int): Spannable {
    val word = SpannableString(text)
    word.setSpan(RelativeSizeSpan(0.8f), 0, start, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    word.setSpan(
        ForegroundColorSpan(ContextCompat.getColor(this, R.color.colorAccent)),
        start, word.length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
    )
    return word
}