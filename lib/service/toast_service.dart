import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';

class ToastService {
  // Simple success toast
  static void showSuccess(String message) {
    showToast(
      message,
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
      backgroundColor: Colors.green,
      radius: 10.0,
      textStyle: TextStyle(fontSize: 14, color: Colors.white),
    );
  }

  // Simple error toast
  static void showError(String message) {
    showToast(
      message,
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
      backgroundColor: Colors.red,
      radius: 10.0,
      textStyle: TextStyle(fontSize: 14, color: Colors.white),
    );
  }

  // Simple info toast
  static void showInfo(String message) {
    showToast(
      message,
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
      backgroundColor: Colors.blue,
      radius: 10.0,
      textStyle: TextStyle(fontSize: 14, color: Colors.white),
    );
  }

  // Warning toast
  static void showWarning(String message) {
    showToast(
      message,
      duration: Duration(seconds: 3),
      position: ToastPosition.bottom,
      backgroundColor: Colors.orange,
      radius: 10.0,
      textStyle: TextStyle(fontSize: 14, color: Colors.white),
    );
  }

  // Long duration toast
  static void showLongToast(String message) {
    showToast(
      message,
      duration: Duration(seconds: 4),
      position: ToastPosition.bottom,
      backgroundColor: Colors.black87,
      radius: 10.0,
    );
  }

  // Custom toast with icon
  static void showCustomToast(String message, {
    required IconData icon,
    required Color color,
  }) {
    showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
    );
  }

  // Loading toast
  static void showLoading(String message) {
    showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
      duration: null, // Infinite until dismissed
      position: ToastPosition.center,
    );
  }

  // Dismiss loading toast
  static void dismissLoading() {
    dismissAllToast(showAnim: true);
  }
}