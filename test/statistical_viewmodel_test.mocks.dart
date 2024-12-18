// Mocks generated by Mockito 5.4.4 from annotations
// in myrefectly/test/statistical_viewmodel_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:hive/hive.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:myrefectly/repository/repository.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBox_0<E> extends _i1.SmartFake implements _i2.Box<E> {
  _FakeBox_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFuture_1<T> extends _i1.SmartFake implements _i3.Future<T> {
  _FakeFuture_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Repository].
///
/// See the documentation for Mockito's code generation for more information.
class MockRepository<I, D> extends _i1.Mock implements _i4.Repository<I, D> {
  MockRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.getter(#name),
        ),
      ) as String);

  @override
  _i2.Box<D> get box => (super.noSuchMethod(
        Invocation.getter(#box),
        returnValue: _FakeBox_0<D>(
          this,
          Invocation.getter(#box),
        ),
      ) as _i2.Box<D>);

  @override
  set box(_i2.Box<D>? _box) => super.noSuchMethod(
        Invocation.setter(
          #box,
          _box,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.Future<void> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<D>> getAll() => (super.noSuchMethod(
        Invocation.method(
          #getAll,
          [],
        ),
        returnValue: _i3.Future<List<D>>.value(<D>[]),
      ) as _i3.Future<List<D>>);

  @override
  _i3.Future<D> getById(I? id) => (super.noSuchMethod(
        Invocation.method(
          #getById,
          [id],
        ),
        returnValue: _i5.ifNotNull(
              _i5.dummyValueOrNull<D>(
                this,
                Invocation.method(
                  #getById,
                  [id],
                ),
              ),
              (D v) => _i3.Future<D>.value(v),
            ) ??
            _FakeFuture_1<D>(
              this,
              Invocation.method(
                #getById,
                [id],
              ),
            ),
      ) as _i3.Future<D>);

  @override
  _i3.Future<void> add(
    I? id,
    D? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #add,
          [
            id,
            data,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> delete(I? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> update(
    I? id,
    D? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [
            id,
            data,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<bool> exists(I? id) => (super.noSuchMethod(
        Invocation.method(
          #exists,
          [id],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<D> getAt(int? index) => (super.noSuchMethod(
        Invocation.method(
          #getAt,
          [index],
        ),
        returnValue: _i5.ifNotNull(
              _i5.dummyValueOrNull<D>(
                this,
                Invocation.method(
                  #getAt,
                  [index],
                ),
              ),
              (D v) => _i3.Future<D>.value(v),
            ) ??
            _FakeFuture_1<D>(
              this,
              Invocation.method(
                #getAt,
                [index],
              ),
            ),
      ) as _i3.Future<D>);

  @override
  _i3.Future<void> clearAll() => (super.noSuchMethod(
        Invocation.method(
          #clearAll,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<int> count() => (super.noSuchMethod(
        Invocation.method(
          #count,
          [],
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);

  @override
  _i3.Future<void> add_all(List<D>? list) => (super.noSuchMethod(
        Invocation.method(
          #add_all,
          [list],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
