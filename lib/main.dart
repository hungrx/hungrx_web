import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/datasource/api/add_category_remote_data_source.dart';
import 'package:hungrx_web/data/datasource/api/category_remote_data_source.dart';
import 'package:hungrx_web/data/datasource/api/category_subcategory_api.dart';
import 'package:hungrx_web/data/datasource/api/get_menu_category_api.dart';
import 'package:hungrx_web/data/datasource/api/menu_api.dart';
import 'package:hungrx_web/data/datasource/api/menu_category_api_service.dart';
import 'package:hungrx_web/data/repositories/add_category_repository.dart';
import 'package:hungrx_web/data/repositories/category_repository_impl.dart';
import 'package:hungrx_web/data/repositories/category_subcategory_repository.dart';
import 'package:hungrx_web/data/repositories/dish_edit_repository.dart';
import 'package:hungrx_web/data/repositories/get_menu_category_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repository_impl.dart';
import 'package:hungrx_web/data/repositories/restaurant_repository.dart';
import 'package:hungrx_web/domain/usecase/create_menu_category_usecase.dart';
import 'package:hungrx_web/domain/usecase/get_categories_usecase.dart';
import 'package:hungrx_web/domain/usecase/get_menu_usecase.dart';
import 'package:hungrx_web/domain/usecase/get_restaurants_usecase.dart';
import 'package:hungrx_web/presentation/bloc/add_restaurant/add_restaurant_bloc.dart';
import 'package:hungrx_web/presentation/bloc/dish_editing/dish_editing_bloc.dart';
import 'package:hungrx_web/presentation/bloc/edit_restaurant/edit_restaurant_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_menu_category/get_menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/login_page/login_page_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_category/menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_catgory_subcategory/menu_category_subcategory_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_catgory_subcategory/menu_category_subcategory_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_bloc.dart';
import 'package:hungrx_web/presentation/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_bloc.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/add_catogory/add_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/restuarant_category_bloc.dart';
import 'routes/app_router.dart';
import 'package:http/http.dart' as http;

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

    final menuApi = MenuApi();
    final menuRepository = MenuRepository(menuApi);
    final getMenuUseCase = GetMenuUseCase(menuRepository);
    final MenuApiService menuApiService = MenuApiService();
    return MultiBlocProvider(
      providers: [
        BlocProvider<DishEditBloc>(
          create: (context) => DishEditBloc(
            repository: DishEditRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => GetMenuCategoryBloc(
            repository: GetMenuCategoryRepository(
              api: GetMenuCategoryApi(
                client: http.Client(),
              ),
            ),
          ),
        ),
        BlocProvider<MenuBloc>(
          create: (_) => MenuBloc(
            getMenuUseCase,
          ),
        ),

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
        BlocProvider<EditRestaurantBloc>(
          create: (context) => EditRestaurantBloc(),
        ),
        BlocProvider<MenuCategoryBloc>(
          create: (context) => MenuCategoryBloc(
            createMenuCategoryUseCase: CreateMenuCategoryUseCase(
              MenuRepositoryImpl(
                apiService: menuApiService,
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => CategorySubcategoryBloc(
            repository: CategorySubcategoryRepository(
              api: CategorySubcategoryApi(),
            ),
          )..add(FetchCategoriesAndSubcategories()),
        ),

        BlocProvider(create: (context) => AddRestaurantBloc()),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(
            getCategoriesUseCase: GetCategoriesUseCase(
              CategoryRepositoryImpl(
                remoteDataSource: CategoryRemoteDataSourceImpl(
                  client: http.Client(),
                ),
              ),
            ),
          ),
        ),
        BlocProvider<AddCategoryBloc>(
          create: (context) => AddCategoryBloc(
            repository: AddCategoryRepository(
              dataSource: AddCategoryDataSource(
                client: http.Client(),
              ),
            ),
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
