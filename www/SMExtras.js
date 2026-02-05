var exec = require('cordova/exec');

exports.apiVersion = 2;

exports.getBuildInfo = function (success, error) {
  exec(success, error, "SMExtras", 'getBuildInfo', []);
};

exports.disableIdleTimeout = function (success, error) {
  exec(success, error, "SMExtras", 'disableIdleTimeout', []);
};

exports.enableIdleTimeout = function (success, error) {
  exec(success, error, "SMExtras", 'enableIdleTimeout', []);
};

exports.getLatency = function(success, error) {
  exec(success, error, "SMExtras", "getLatency", []);
};

/**
 * Android-only methods:
 */

exports.share = function(args, success, error) {
  if ( /Android/i.test(navigator.userAgent) ) {
    exec(success, error, "SMExtras", "share", [args.text || "", args.title || "", args.url || ""]);
  }
};

/**
 * iOS-only methods:
 */

exports.detectMuteSwitch = function(success, error) {
  if ( !/Android/i.test(navigator.userAgent) ) {
    exec(success, error, "SMExtras", "detectMuteSwitch", []);
  }
};

exports.openURL = function(url, success, error) {
  if ( !/Android/i.test(navigator.userAgent) ) {
    exec(success, error, "SMExtras", "openURL", [url]);
  }
};

exports.manageSubscriptions = function(success, error) {
  if ( !/Android/i.test(navigator.userAgent) ) {
    exec(success, error, "SMExtras", "manageSubscriptions", []);
  }
};

exports.requestAppReview = function(success, error) {
  if ( !/Android/i.test(navigator.userAgent) ) {
    exec(success, error, "SMExtras", "requestAppReview", []);
  }
};

exports.getTextScaleFactor = function(success, error) {
  if ( !/Android/i.test(navigator.userAgent) ) {
    exec(success, error, "SMExtras", "getTextScaleFactor", []);
  }
};

exports.watchTextScaleFactor = function(success, error) {
  if ( !/Android/i.test(navigator.userAgent) ) {
    exec(success, error, "SMExtras", "watchTextScaleFactor", []);
  }
};
