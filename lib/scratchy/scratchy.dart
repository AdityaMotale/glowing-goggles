import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:demo/scratchy/painter.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

const _progressReportStep = 0.1;

enum Accuracy {
  low,
  medium,
  high,
}

double _accuracyVal(Accuracy accuracy) {
  switch (accuracy) {
    case Accuracy.low:
      return 10.0;
    case Accuracy.medium:
      return 30.0;
    case Accuracy.high:
      return 100.0;
  }
}

class Scratchy extends StatefulWidget {
  const Scratchy({
    Key? key,
    required this.child,
    this.accuracy = Accuracy.high,
    this.enabled = true,
    this.threshold,
    this.brushSize = 40,
    this.color = Colors.black12,
    this.image,
    this.rebuildOnResize = true,
    this.onChange,
    this.onThreshold,
    this.onStart,
    this.onUpdate,
    this.onEnd,
  }) : super(key: key);

  final Widget child;
  final bool enabled;
  final double? threshold;
  final double? brushSize;
  final Accuracy accuracy;
  final Color color;
  final Image? image;
  final bool rebuildOnResize;
  final Function(double val)? onChange;

  final VoidCallback? onThreshold;
  final VoidCallback? onStart;
  final VoidCallback? onUpdate;
  final VoidCallback? onEnd;

  @override
  State<Scratchy> createState() => _ScratchyState();
}

class _ScratchyState extends State<Scratchy> {
  late Future<ui.Image?> _loadImg;
  Offset? _prevPose;

  List<ScratchPoint?> points = [];
  late Set<Offset> checkPoints;
  Set<Offset> checked = {};
  int totalCheckPoints = 0;
  double progress = 0;
  double progressReported = 0;
  bool threshHoldReported = false;
  bool isFinished = false;
  bool canScratch = true;
  Duration? transitionDuration;
  Size? _lastSize;

  RenderBox? get _renderObj {
    return context.findRenderObject() as RenderBox?;
  }

  @override
  void initState() {
    super.initState();

    if (widget.image == null) {
      final completer = Completer<ui.Image?>()..complete();
      _loadImg = completer.future;
    } else {
      _loadImg = _loadImage(widget.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image?>(
      future: _loadImg,
      builder: (BuildContext context, AsyncSnapshot<ui.Image?> snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: canScratch
                ? (details) {
                    widget.onStart?.call();
                    if (widget.enabled) {
                      _addPoint(details.localPosition);
                    }
                  }
                : null,
            onPanUpdate: canScratch
                ? (details) {
                    widget.onUpdate?.call();
                    if (widget.enabled) {
                      _addPoint(details.localPosition);
                    }
                  }
                : null,
            onPanEnd: canScratch
                ? (details) {
                    widget.onEnd?.call();
                    if (widget.enabled) {
                      setState(() => points.add(null));
                    }
                  }
                : null,
            child: AnimatedSwitcher(
              duration: transitionDuration ?? Duration.zero,
              child: isFinished
                  ? widget.child
                  : CustomPaint(
                      foregroundPainter: CardPainter(
                        image: snapshot.data,
                        boxFit: widget.image == null
                            ? null
                            : widget.image!.fit ?? BoxFit.cover,
                        color: widget.color,
                        onDraw: (size) {
                          if (_lastSize == null) {
                            _setCheckpoints(size);
                          } else if (_lastSize != size &&
                              widget.rebuildOnResize) {
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              reset();
                            });
                          }

                          _lastSize = size;
                        },
                        scratchPoints: points,
                      ),
                      child: widget.child,
                    ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Future<ui.Image> _loadImage(Image image) async {
    final completer = Completer<ui.Image>();
    final imageProvider = image.image as dynamic;
    final key = await imageProvider.obtainKey(const ImageConfiguration());

    imageProvider.load(key, (
      Uint8List bytes, {
      int? cacheWidth,
      int? cacheHeight,
      bool? allowUpscaling,
    }) async {
      return ui.instantiateImageCodec(bytes);
    }).addListener(ImageStreamListener((ImageInfo image, _) {
      completer.complete(image.image);
    }));

    return completer.future;
  }

  void _addPoint(Offset position) {
    // Ignore when same point is reported multiple times in a row
    if (_prevPose == position) {
      return;
    }
    _prevPose = position;

    ui.Offset? point = position;

    // Ignore when starting point of new line has been already scratched
    // ignore: iterable_contains_unrelated_type
    if (points.isNotEmpty && points.contains(point)) {
      if (points.last == null) {
        return;
      } else {
        point = null;
      }
    }

    setState(() {
      points.add(ScratchPoint(point, widget.brushSize!));
    });

    if (point != null && !checked.contains(point)) {
      checked.add(point);

      final radius = widget.brushSize! / 2;
      checkPoints.removeWhere(
        (checkpoint) => _inCircle(checkpoint, point!, radius),
      );

      progress =
          ((totalCheckPoints - checkPoints.length) / totalCheckPoints) * 100;
      if (progress - progressReported >= _progressReportStep ||
          progress == 100) {
        progressReported = progress;
        widget.onChange?.call(progress);
      }

      if (!threshHoldReported &&
          widget.threshold != null &&
          progress >= widget.threshold!) {
        threshHoldReported = true;
        widget.onThreshold?.call();
      }

      if (progress == 100) {
        isFinished = true;
      }
    }
  }

  void _setCheckpoints(Size size) {
    final calculated = _calculateCheckpoints(size).toSet();

    checkPoints = calculated;
    totalCheckPoints = calculated.length;
  }

  List<Offset> _calculateCheckpoints(Size size) {
    final accuracy = _accuracyVal(widget.accuracy);
    final xOffset = size.width / accuracy;
    final yOffset = size.height / accuracy;

    final points = <Offset>[];
    for (var x = 0; x < accuracy; x++) {
      for (var y = 0; y < accuracy; y++) {
        final point = Offset(
          x * xOffset,
          y * yOffset,
        );
        points.add(point);
      }
    }

    return points;
  }

  /// Resets the scratcher state to the initial values.
  void reset({Duration? duration}) {
    setState(() {
      transitionDuration = duration;
      isFinished = false;
      canScratch = duration == null;
      threshHoldReported = false;

      _prevPose = null;
      points = [];
      checked = {};
      progress = 0;
      progressReported = 0;
    });

    // Do not allow to scratch during transition
    if (duration != null) {
      Future.delayed(duration, () {
        setState(() {
          canScratch = true;
        });
      });
    }

    _setCheckpoints(_renderObj!.size);
    widget.onChange?.call(0);
  }

  /// Reveals the whole scratcher, so than only original child is displayed.
  void reveal({Duration? duration}) {
    setState(() {
      transitionDuration = duration;
      isFinished = true;
      canScratch = false;
      if (!threshHoldReported && widget.threshold != null) {
        threshHoldReported = true;
        widget.onThreshold?.call();
      }
    });

    widget.onChange?.call(100);
  }

  bool _inCircle(Offset center, Offset point, double radius) {
    final dX = center.dx - point.dx;
    final dY = center.dy - point.dy;
    final multi = dX * dX + dY * dY;
    final distance = sqrt(multi).roundToDouble();

    return distance <= radius;
  }
}
