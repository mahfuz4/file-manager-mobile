import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/pin_provider.dart';
import '../theme/app_theme.dart';

class PinSetupScreen extends StatefulWidget {
  final bool isChanging;
  const PinSetupScreen({super.key, this.isChanging = false});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _pinCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isConfirming = false;
  String? _error;
  String _firstPin = '';

  @override
  void dispose() {
    _pinCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onPinComplete(String pin) async {
    if (!_isConfirming) {
      _firstPin = pin;
      setState(() {
        _isConfirming = true;
        _error = null;
      });
      _pinCtrl.clear();
    } else {
      if (pin == _firstPin) {
        final provider = context.read<PinProvider>();
        await provider.setPin(pin);
        if (mounted) Navigator.of(context).pop(true);
      } else {
        setState(() {
          _error = 'PINs do not match';
          _isConfirming = false;
          _firstPin = '';
        });
        _pinCtrl.clear();
        _confirmCtrl.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(
          widget.isChanging ? 'Change PIN' : 'Set PIN',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: AppTheme.primary),
              const SizedBox(height: 24),
              Text(
                _isConfirming ? 'Confirm your PIN' : 'Enter a 4-digit PIN',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 32),
              _PinInput(
                controller: _isConfirming ? _confirmCtrl : _pinCtrl,
                onComplete: _onPinComplete,
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: TextStyle(color: AppTheme.destructive)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PinInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onComplete;

  const _PinInput({required this.controller, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        obscureText: true,
        maxLength: 4,
        style: const TextStyle(fontSize: 32, letterSpacing: 16, color: Colors.white),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.border),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primary),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (val) {
          if (val.length == 4) onComplete(val);
        },
      ),
    );
  }
}
