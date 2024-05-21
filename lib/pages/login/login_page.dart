import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius_lens/api/request/user.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../data/exception/api_exception.dart';
import '../../provider/user_provider.dart';
import '../../router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TapGestureRecognizer _serviceProtocolRecognizer;
  late final TapGestureRecognizer _privacyProtocolRecognizer;
  bool _isPasswordVisible = false;
  bool _agree = false;

  final BoxDecoration _inputDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _serviceProtocolRecognizer = TapGestureRecognizer();
    _privacyProtocolRecognizer = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Image.asset('assets/logo.png', width: 128, height: 128),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            decoration: _inputDecoration,
            child: TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: '请输入用户名',
                prefixIcon: Icon(Icons.person),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            decoration: _inputDecoration,
            child: TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: '请输入密码',
                prefixIcon: const Icon(Icons.lock),
                suffix: GestureDetector(
                  onTap: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              Checkbox(
                  value: _agree,
                  shape: const CircleBorder(),
                  onChanged: (value) {
                    setState(() => _agree = value ?? false);
                  }),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: '我已阅读并同意',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                        text: '《用户协议》',
                        style: const TextStyle(color: Colors.blueAccent),
                        recognizer: _serviceProtocolRecognizer
                          ..onTap = () {
                            EasyLoading.showInfo('用户协议');
                          }),
                    const TextSpan(
                      text: '和',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: '《隐私政策》',
                      style: const TextStyle(color: Colors.blueAccent),
                      recognizer: _privacyProtocolRecognizer
                        ..onTap = () {
                          EasyLoading.showInfo('隐私政策');
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  if (!_agree) {
                    EasyLoading.showInfo('请先同意用户协议和隐私政策');
                    return;
                  }
                  // 显示Loading
                  EasyLoading.show(status: '登录中...');
                  try {
                    var user = await UserApi.login();
                    context.read<UserProvider>().updateUserInfo(user);
                    EasyLoading.dismiss();
                    Get.offAllNamed(AppRouter.root);
                  } on WrongPasswordException catch (e) {
                    EasyLoading.showError(e.message);
                  } catch (e) {
                    // e.printError();
                    EasyLoading.showError('登录失败');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
