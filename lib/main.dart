import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_bloc.dart';
import 'package:kinds_memory_game/domain/bloc/memory_game_bloc/memory_game_event.dart';
import 'package:kinds_memory_game/presentation/home/view/memory_game_view.dart';

void main() {
  runApp(const MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), //! iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Memory Match Game',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.purple,
          ),
          home: BlocProvider(
            create: (context) => MemoryGameBloc()..add(InitializeGameEvent()),
            child: const MemoryGameView(),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
