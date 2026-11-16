import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/studio_tokens.dart';
import '../../core/widgets/back_navigation.dart';

enum AuthMode { signIn, signUp }

@immutable
class AuthFormData {
  const AuthFormData({
    required this.mode,
    required this.email,
    required this.password,
    this.name,
    this.rememberFor30Days = false,
    this.acceptedTerms = false,
  });

  final AuthMode mode;
  final String email;
  final String password;
  final String? name;
  final bool rememberFor30Days;
  final bool acceptedTerms;
}

class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({
    super.key,
    this.initialMode = AuthMode.signIn,
    this.onSubmit,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  final AuthMode initialMode;
  final ValueChanged<AuthFormData>? onSubmit;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  State<AdminAuthScreen> createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AuthMode _mode = widget.initialMode;
  bool _rememberFor30Days = false;
  bool _acceptedTerms = false;
  bool _obscurePassword = true;

  bool get _isSignUp => _mode == AuthMode.signUp;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudioTokens.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 480 ? 24.0 : 40.0;
            final footerGap = (constraints.maxHeight - (_isSignUp ? 720 : 640))
                .clamp(48.0, 220.0)
                .toDouble();
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: AppBackButton(fallbackLocation: '/'),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isSignUp ? 'Get Started Now' : 'Welcome back!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontSize: 38),
                          ),
                          const SizedBox(height: 36),
                          const _StudioWordmark(),
                          const SizedBox(height: 40),
                          if (!_isSignUp) ...[
                            Text(
                              'Enter your credentials to access your account',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 28),
                          ],
                          if (_isSignUp) ...[
                            _AuthField(
                              label: 'Name',
                              hint: 'Enter your name',
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Enter your name'
                                  : null,
                            ),
                            const SizedBox(height: 20),
                          ],
                          _AuthField(
                            label: 'Email address',
                            hint: 'Enter your email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                  .hasMatch(email)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _AuthField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              tooltip: _obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white70,
                              ),
                            ),
                            validator: (value) {
                              if ((value ?? '').length < 8) {
                                return 'Use at least 8 characters';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 16),
                          if (_isSignUp)
                            _TermsConsent(
                              accepted: _acceptedTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptedTerms = value ?? false;
                                });
                              },
                              onTermsTap: widget.onTermsTap,
                              onPrivacyTap: widget.onPrivacyTap,
                            )
                          else
                            _RememberCheckbox(
                              value: _rememberFor30Days,
                              onChanged: (value) {
                                setState(() {
                                  _rememberFor30Days = value ?? false;
                                });
                              },
                            ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 56,
                            child: FilledButton(
                              onPressed: _submit,
                              child: Text(
                                _isSignUp ? 'Sign Up' : 'Login',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: footerGap),
                          _ModeSwitcher(
                            isSignUp: _isSignUp,
                            onTap: _toggleMode,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _mode = _isSignUp ? AuthMode.signIn : AuthMode.signUp;
      _formKey.currentState?.reset();
      _rememberFor30Days = false;
      _acceptedTerms = false;
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSignUp && !_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and policy.')),
      );
      return;
    }

    widget.onSubmit?.call(
      AuthFormData(
        mode: _mode,
        name: _isSignUp ? _nameController.text.trim() : null,
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberFor30Days: !_isSignUp && _rememberFor30Days,
        acceptedTerms: _isSignUp && _acceptedTerms,
      ),
    );
  }
}

class _StudioWordmark extends StatelessWidget {
  const _StudioWordmark();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'BLACKBOX',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 38,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'STUDIO',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 30,
                fontStyle: FontStyle.italic,
                color: StudioTokens.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.star, color: StudioTokens.accent, size: 18),
          ],
        ),
      ],
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onFieldSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF77736A)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Colors.white70, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            enabledBorder: outline,
            focusedBorder: outline.copyWith(
              borderSide: const BorderSide(
                color: StudioTokens.accent,
                width: 1.5,
              ),
            ),
            errorBorder: outline.copyWith(
              borderSide: const BorderSide(color: StudioTokens.alert),
            ),
            focusedErrorBorder: outline.copyWith(
              borderSide: const BorderSide(color: StudioTokens.alert),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class _RememberCheckbox extends StatelessWidget {
  const _RememberCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        'Remember for 30 days',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
      ),
      activeColor: StudioTokens.accent,
      checkColor: StudioTokens.background,
      side: const BorderSide(color: Colors.white),
    );
  }
}

class _TermsConsent extends StatelessWidget {
  const _TermsConsent({
    required this.accepted,
    required this.onChanged,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  final bool accepted;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: accepted,
          onChanged: onChanged,
          activeColor: StudioTokens.accent,
          checkColor: StudioTokens.background,
          side: const BorderSide(color: Colors.white),
        ),
        Expanded(
          child: Wrap(
            children: [
              Text(
                'I agree to the ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              _PolicyLink(label: 'terms', onTap: onTermsTap),
              Text(' & ', style: Theme.of(context).textTheme.bodyMedium),
              _PolicyLink(label: 'policy', onTap: onPrivacyTap),
            ],
          ),
        ),
      ],
    );
  }
}

class _PolicyLink extends StatelessWidget {
  const _PolicyLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: StudioTokens.accent,
          decoration: TextDecoration.underline,
          decorationColor: StudioTokens.accent,
        ),
      ),
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  const _ModeSwitcher({required this.isSignUp, required this.onTap});

  final bool isSignUp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(
          isSignUp ? 'Have an account?' : 'Don’t have an account?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: StudioTokens.accent,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: Text(isSignUp ? 'Sign In' : 'Sign Up'),
        ),
      ],
    );
  }
}
