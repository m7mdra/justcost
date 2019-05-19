import 'package:flutter/material.dart';

typedef ValueChanged<String> OnChange(String value);
typedef ValueChanged<String> OnCodeChange(String value);
typedef ValueChanged OnComplete(bool completed);

class VerificationCodeWidget extends StatefulWidget {
  final int count;
  final InputDecoration cellsInputDecoration;
  final TextStyle cellsTextStyle;
  final OnCodeChange onCodeChange;
  final OnComplete onComplete;
  final bool obscureText;

  const VerificationCodeWidget(this.count,
      {Key key,
        this.onCodeChange,
        this.onComplete,
        this.cellsInputDecoration,
        this.cellsTextStyle,
        this.obscureText})
      : super(key: key);

  @override
  VerificationCodeWidgetState createState() => VerificationCodeWidgetState();
}

class VerificationCodeWidgetState extends State<VerificationCodeWidget> {
  final List<FocusNode> _nodes = [];
  final List<TextEditingController> _textEditingControllers = [];
  final List<CodeDigitWidget> _digitWidgets = [];
  int _count;

  void clearCells() {
    _textEditingControllers.forEach((controller) => controller.clear());
    FocusScope.of(context).requestFocus(_nodes[0]);
  }

  void _generate() {
    for (var i = 0; i < _count; i++) {
      var controller = TextEditingController();
      var node = FocusNode();
      _nodes.add(node);
      _textEditingControllers.add(controller);
      _digitWidgets.add(CodeDigitWidget(
        key: UniqueKey(),
        cellSize: Size(50, 50),
        focusNode: node,
        textEditingController: controller,
        onChange: (value) {
          widget.onCodeChange(_textEditingControllers
              .map((controller) => controller.text)
              .reduce((first, second) {
            return first + second;
          }));
          if (value.isEmpty) {
            if (_nodes[i - 1] != null) {
              var node = _nodes[i - 1];
              FocusScope.of(context).requestFocus(node);
            }
          } else {
            if (_nodes[i + 1] != null) {
              var node = _nodes[i + 1];
              FocusScope.of(context).requestFocus(node);
            }
          }
          print("$i + 1 == $_count - 1");
          widget.onComplete(i + 1 == _count - 1);
        },
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _count = widget.count;
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _digitWidgets,
      ),
    );
  }
}

class CodeDigitWidget extends StatelessWidget {
  final FocusNode focusNode;
  final OnChange onChange;
  final bool obscureText;
  final TextEditingController textEditingController;
  final double marginBetweenCells;
  final Size cellSize;
  final InputDecoration cellsInputDecoration;
  final TextStyle cellsTextStyle;
  final _defaultTextStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
  final _defaultInputBorder = const InputDecoration(
      filled: true,
      counterText: '',
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))));

  const CodeDigitWidget({
    Key key,
    this.focusNode,
    this.onChange,
    this.obscureText,
    this.textEditingController,
    this.marginBetweenCells,
    this.cellSize,
    this.cellsInputDecoration,
    this.cellsTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellSize.width ?? 50,
      height: cellSize.height ?? 50,
      margin: EdgeInsets.all(marginBetweenCells ?? 4),
      child: TextField(
        textAlign: TextAlign.center,
        key: key,
        focusNode: focusNode,
        controller: textEditingController,
        maxLines: 1,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onChanged: onChange,
        maxLength: 1,
        obscureText: obscureText ?? false,
        style: cellsTextStyle ?? _defaultTextStyle,
        maxLengthEnforced: true,
        decoration: cellsInputDecoration ?? _defaultInputBorder,
        enableInteractiveSelection: false,
      ),
    );
  }
}