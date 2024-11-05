// In your main.dart file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/repositories/restaurant_repository.dart';
import 'package:hungrx_web/domain/usecase/get_restaurants_usecase.dart';
import 'package:hungrx_web/presentation/bloc/login_page/login_page_bloc.dart';
import 'package:hungrx_web/presentation/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_bloc.dart';
import 'routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantRepository = RestaurantRepository();
    final getRestaurantsUseCase =
        GetRestaurantsUseCase(repository: restaurantRepository);
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhoneLoginBloc>(
          create: (context) => PhoneLoginBloc(),
        ),
        BlocProvider<OtpVerificationBloc>(
            create: (context) => OtpVerificationBloc()),

        BlocProvider<RestaurantBloc>(
          create: (context) => RestaurantBloc(
            getRestaurantsUseCase: getRestaurantsUseCase,
          ),
        ),

        // Add more BlocProviders here
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant Admin',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
