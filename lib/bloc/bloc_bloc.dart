import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/bloc/repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String email;
  final String username;
  final String password;

  const RegisterEvent({required this.email, required this.username, required this.password});

  @override
  List<Object> get props => [email, username, password];
}

class DarkModeEvent extends AuthEvent {}

class LightModeEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;

  const Authenticated({required this.token});

  @override
  List<Object> get props => [token];
}

class Unauthenticated extends AuthState {}

class ThemeState extends AuthState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme mode

  ThemeMode get themeMode => _themeMode;

  AuthBloc({required this.userRepository}) : super(AuthInitial()) {
    // Register the event handlers
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RegisterEvent>(_onRegister);
    on<DarkModeEvent>(_onDarkMode);
    on<LightModeEvent>(_onLightMode);
  }

  // Event handler for LoginEvent
  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await userRepository.login(event.email, event.password);
      emit(Authenticated(token: token));
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  // Event handler for LogoutEvent
  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    emit(Unauthenticated());
  }

  // Event handler for RegisterEvent
  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await userRepository.createUser(event.email, event.username, event.password);
      emit(Unauthenticated()); // After registration, go to login screen
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  // Event handler for DarkModeEvent
  void _onDarkMode(DarkModeEvent event, Emitter<AuthState> emit) {
    _themeMode = ThemeMode.dark;
    emit(ThemeState(themeMode: _themeMode));
  }

  // Event handler for LightModeEvent
  void _onLightMode(LightModeEvent event, Emitter<AuthState> emit) {
    _themeMode = ThemeMode.light;
    emit(ThemeState(themeMode: _themeMode));
  }
}

