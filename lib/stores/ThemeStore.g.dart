// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ThemeStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$ThemeStore on _ThemeStore, Store {
  final _$themeAppAtom = Atom(name: '_ThemeStore.themeApp');

  @override
  ThemeApp get themeApp {
    _$themeAppAtom.context.enforceReadPolicy(_$themeAppAtom);
    _$themeAppAtom.reportObserved();
    return super.themeApp;
  }

  @override
  set themeApp(ThemeApp value) {
    _$themeAppAtom.context.conditionallyRunInAction(() {
      super.themeApp = value;
      _$themeAppAtom.reportChanged();
    }, _$themeAppAtom, name: '${_$themeAppAtom.name}_set');
  }

  final _$_ThemeStoreActionController = ActionController(name: '_ThemeStore');

  @override
  void setTheme(String theme) {
    final _$actionInfo = _$_ThemeStoreActionController.startAction();
    try {
      return super.setTheme(theme);
    } finally {
      _$_ThemeStoreActionController.endAction(_$actionInfo);
    }
  }
}
