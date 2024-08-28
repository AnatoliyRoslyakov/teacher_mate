import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teacher_mate/core/router/app_router.dart';

/// Signature for a function to buildCustom Toast
typedef PositionedToastBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

/// Runs on dart side this has no interaction with the Native Side
/// Works with all platforms just in two lines of code
/// final fToast = FToast().init(context)
/// fToast.showToast(child)
///
class Toster {
  static final Toster _instance = Toster._internal();

  /// Prmary Constructor for FToast
  factory Toster() {
    return _instance;
  }

  Toster._internal();

  OverlayEntry? _entry;
  final List<_ToastEntry> _overlayQueue = [];
  Timer? _timer;
  Timer? _fadeTimer;

  void show(
    Widget child, {
    PositionedToastBuilder? positionedToastBuilder,
  }) {
    final overlay = AppRouter.rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;
    final builder = positionedToastBuilder ??
        (context, child) {
          return Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 24,
            left: 24,
            child: child,
          );
        };
    showToast(
      child: child,
      overlayState: overlay,
      positionedToastBuilder: builder,
    );
  }

  /// Internal function which handles the adding
  /// the overlay to the screen
  ///
  void _showOverlay(
    OverlayState overlayState,
  ) {
    if (_overlayQueue.isEmpty) {
      _entry = null;
      return;
    }

    /// Create entry only after all checks
    final _ToastEntry toastEntry = _overlayQueue.removeAt(0);
    _entry = toastEntry.entry;
    overlayState.insert(_entry!);

    _timer = Timer(toastEntry.duration, () {
      _fadeTimer = Timer(toastEntry.fadeDuration, () {
        removeCustomToast(overlayState);
      });
    });
  }

  /// If any active toast present
  /// call removeCustomToast to hide the toast immediately
  void removeCustomToast(
    OverlayState overlayState,
  ) {
    _timer?.cancel();
    _fadeTimer?.cancel();
    _timer = null;
    _fadeTimer = null;
    _entry?.remove();
    _entry = null;
    _showOverlay(overlayState);
  }

  /// FToast maintains a queue for every toast
  /// if we called showToast for 3 times we all to queue
  /// and show them one after another
  ///
  /// call removeCustomToast to hide the toast immediately
  void removeQueuedCustomToasts() {
    _timer?.cancel();
    _fadeTimer?.cancel();
    _timer = null;
    _fadeTimer = null;
    _overlayQueue.clear();
    _entry?.remove();
    _entry = null;
  }

  /// showToast accepts all the required paramenters and prepares the child
  /// calls _showOverlay to display toast
  ///
  /// Paramenter [child] is requried
  /// toastDuration default is 2 seconds
  /// fadeDuration default is 350 milliseconds
  void showToast({
    required Widget child,
    required OverlayState overlayState,
    PositionedToastBuilder? positionedToastBuilder,
    Duration toastDuration = const Duration(seconds: 2),
    // ToastGravity? gravity,
    Duration fadeDuration = const Duration(milliseconds: 350),
    bool ignorePointer = false,
    bool isDismissable = false,
  }) {
    final Widget newChild = _ToastStateFul(
      child,
      toastDuration,
      fadeDuration,
      ignorePointer,
      !isDismissable
          ? null
          : () {
              removeCustomToast(overlayState);
            },
    );

    final OverlayEntry newEntry = OverlayEntry(
      builder: (context) {
        if (positionedToastBuilder != null)
          return positionedToastBuilder(context, newChild);
        return Positioned(bottom: 50.0, left: 24.0, right: 24.0, child: child);
      },
    );
    _overlayQueue.add(
      _ToastEntry(
        entry: newEntry,
        duration: toastDuration,
        fadeDuration: fadeDuration,
      ),
    );
    if (_timer == null) _showOverlay(overlayState);
  }
}

/// internal class [_ToastEntry] which maintains
/// each [OverlayEntry] and [Duration] for every toast user
/// triggered
class _ToastEntry {
  final OverlayEntry entry;
  final Duration duration;
  final Duration fadeDuration;

  _ToastEntry({
    required this.entry,
    required this.duration,
    required this.fadeDuration,
  });
}

/// internal [StatefulWidget] which handles the show and hide
/// animations for [FToast]
class _ToastStateFul extends StatefulWidget {
  const _ToastStateFul(
    this.child,
    this.duration,
    this.fadeDuration,
    this.ignorePointer,
    this.onDismiss,
  );

  final Widget child;
  final Duration duration;
  final Duration fadeDuration;
  final bool ignorePointer;
  final VoidCallback? onDismiss;

  @override
  ToastStateFulState createState() => ToastStateFulState();
}

/// State for [_ToastStateFul]
class ToastStateFulState extends State<_ToastStateFul>
    with SingleTickerProviderStateMixin {
  /// Start the showing animations for the toast
  void showIt() {
    _animationController!.forward();
  }

  /// Start the hidding animations for the toast
  void hideIt() {
    _animationController!.reverse();
    _timer?.cancel();
  }

  /// Controller to start and hide the animation
  AnimationController? _animationController;
  late Animation<double> _fadeAnimation;

  Timer? _timer;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn);
    super.initState();

    showIt();
    _timer = Timer(widget.duration, () {
      hideIt();
    });
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _animationController!.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss == null ? null : () => widget.onDismiss!(),
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        ignoring: widget.ignorePointer,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
