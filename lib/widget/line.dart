abstract class Line {}

class SolidLine extends Line {}

class DashedLine extends Line {
  final double? dashSize;
  final double? gapSize;

  DashedLine({this.dashSize, this.gapSize});
}
