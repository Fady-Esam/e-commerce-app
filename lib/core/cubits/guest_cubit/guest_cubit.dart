

import 'package:flutter_bloc/flutter_bloc.dart';

import 'guest_state.dart';

class GuestCubit extends Cubit<GuestState> {
  GuestCubit() : super(GuestInitial());
  bool isUserGuest = true;
  void setIsGuest({required bool isGuest}){
    isUserGuest = isGuest;
    emit(GuestCheckState());
  }
}
