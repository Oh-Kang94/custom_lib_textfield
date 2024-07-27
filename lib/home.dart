import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<FocusNode> _focusNodes = [];
  final List<TextEditingController> _controllers = [];
  final ScrollController _scrollController = ScrollController();
  final FocusNode buttonsFocusNode = FocusNode();

  String? accountHelper;
  String? passwordHelper;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    int numberOfFields = 7;

    // FocusNode와 TextEditingController를 동적으로 생성
    for (int i = 0; i < numberOfFields; i++) {
      _focusNodes.add(FocusNode());
      _controllers.add(TextEditingController());
    }

    // 각 FocusNode에 리스너 추가
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToFocusNode(_focusNodes[i]);
          });
        }
      });
    }
  }

  void setAccountHelper() {
    setState(() {
      accountHelper = validateAccount(_controllers[0].text);
    });
  }

  void setPasswordHelper() {
    setState(() {
      passwordHelper = validatePassword(_controllers[1].text);
    });
  }

  String? validateAccount(String value) {
    const pattern = r'^\d{11}$';
    final regex = RegExp(pattern);
    if (value.isEmpty) return '아이디를 입력하세요.';
    if (!regex.hasMatch(value)) {
      return '아이디는 11자 숫자 조합으로 가능합니다.';
    }
    return null;
  }

  String? validatePassword(String value) {
    final regex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$');
    if (value.isEmpty) {
      return '비밀번호를 입력하세요.';
    } else if (!regex.hasMatch(value)) {
      return '영문, 숫자, 특수문자를 모두 조합하여 8자~16자리로 입력해주세요.';
    } else {
      return null;
    }
  }

  Future<void> _scrollToFocusNode(FocusNode focusNode) async {
    if (!mounted) return;

    final context = focusNode.context;
    if (context != null) {
      final renderBox = context.findRenderObject() as RenderBox?;
      final offset = renderBox?.localToGlobal(Offset.zero);
      if (offset != null) {
        final screenHeight = MediaQuery.of(context).size.height;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final fieldTop = offset.dy;
        final fieldHeight = renderBox?.size.height ?? 0.0;
        final availableHeight = screenHeight - keyboardHeight;
        final scrollPosition =
            fieldTop - (availableHeight / 2) + (fieldHeight / 2);

        _scrollController.animateTo(
          scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].dispose();
      _controllers[i].dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // 가로 방향으로 확장
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      TextField(
                        controller: _controllers[0],
                        focusNode: _focusNodes[0],
                        decoration: InputDecoration(
                          labelText: '아이디',
                          errorText: accountHelper,
                        ),
                        onEditingComplete: () => _fieldFocusChange(context,
                            _focusNodes[0], _focusNodes[1], setAccountHelper),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _controllers[1],
                        focusNode: _focusNodes[1],
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          errorText: passwordHelper,
                        ),
                        obscureText: true,
                        onEditingComplete: () => _fieldFocusChange(context,
                            _focusNodes[1], _focusNodes[2], setPasswordHelper),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _controllers[2],
                        focusNode: _focusNodes[2],
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          errorText: passwordHelper,
                        ),
                        obscureText: true,
                        onEditingComplete: () => _fieldFocusChange(context,
                            _focusNodes[2], _focusNodes[3], setPasswordHelper),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _controllers[3],
                        focusNode: _focusNodes[3],
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          errorText: passwordHelper,
                        ),
                        obscureText: true,
                        onEditingComplete: () => _fieldFocusChange(context,
                            _focusNodes[3], _focusNodes[4], setPasswordHelper),
                      ),
                      TextField(
                        controller: _controllers[4],
                        focusNode: _focusNodes[4],
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          errorText: passwordHelper,
                        ),
                        obscureText: true,
                        onEditingComplete: () => _fieldFocusChange(context,
                            _focusNodes[4], _focusNodes[5], setPasswordHelper),
                      ),
                      TextField(
                        controller: _controllers[5],
                        focusNode: _focusNodes[5],
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          errorText: passwordHelper,
                        ),
                        obscureText: true,
                        onEditingComplete: () => _fieldFocusChange(
                            context,
                            _focusNodes[5],
                            buttonsFocusNode,
                            setPasswordHelper),
                      ),
                      SizedBox(
                        height: 300,
                      ),
                      Focus(
                        focusNode: buttonsFocusNode,
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () => _fieldFocusChange(
                                      context,
                                      buttonsFocusNode,
                                      _focusNodes[6],
                                      () {},
                                    ),
                                child: Text("OK"))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode? nextFocus, void Function() onFocusChange) {
    onFocusChange();
    currentFocus.unfocus();
    if (nextFocus != null) {
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }
}
