import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/add_menu_subcategory_api.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/dropdown_menu_category_api.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/edit_menu_category_api_service.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/get_category_subcategory_api.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/quick_search_api.dart';
import 'package:hungrx_web/data/datasource/api/resturant_api/add_category_remote_data_source.dart';
import 'package:hungrx_web/data/datasource/api/resturant_api/category_remote_data_source.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/menu_api.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/add_menu_category_api_service.dart';
import 'package:hungrx_web/data/repositories/menu_repo/add_menu_subcategory_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/dropdown_menu_category_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/edit_category_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/get_category_subcategory_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/get_dropdown_menu_categories.dart';
import 'package:hungrx_web/data/repositories/menu_repo/quick_search_repository.dart';
import 'package:hungrx_web/data/repositories/restaurant_repo/add_category_repository.dart';
import 'package:hungrx_web/data/repositories/restaurant_repo/category_repository_impl.dart';
import 'package:hungrx_web/data/repositories/menu_repo/dish_edit_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/menu_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/menu_repository_impl.dart';
import 'package:hungrx_web/data/repositories/restaurant_repo/restaurant_repository.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/create_menu_category_usecase.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/create_menu_subcategory.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/edit_category_usecase.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/get_categories_and_subcategories.dart';
import 'package:hungrx_web/domain/usecase/restaurant_usecase/get_categories_usecase.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/get_menu_usecase.dart';
import 'package:hungrx_web/domain/usecase/restaurant_usecase/get_restaurants_usecase.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_subcategory/add_menu_subcategory_bloc.dart';
import 'package:hungrx_web/presentation/bloc/add_restaurant/add_restaurant_bloc.dart';
import 'package:hungrx_web/presentation/bloc/dish_editing/dish_editing_bloc.dart';
import 'package:hungrx_web/presentation/bloc/dropdown_menu_category/dropdown_menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/edit_menu_category/edit_menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/edit_restaurant/edit_restaurant_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_category_subcategory/get_category_subcategory_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/login_page/login_page_bloc.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_main_category/menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_quick_search/menu_quick_search_dialog_bloc.dart';
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
    final dropdownMenuCategoryApi = DropdownMenuCategoryApi(
      baseUrl: ApiConstants.baseUrl,
    );
    final dropdownMenuCategoryRepository = DropdownMenuCategoryRepository(
      api: dropdownMenuCategoryApi,
    );
    final getDropdownMenuCategories = GetDropdownMenuCategories(
      repository: dropdownMenuCategoryRepository,
    );
    final restaurantRepository = RestaurantRepository();
    final getRestaurantsUseCase =
        GetRestaurantsUseCase(repository: restaurantRepository);
    final categoryApiService = CategoryApiService();
    late final categoryRepository = CategoryRepository(categoryApiService);
    late final editCategoryUseCase = EditCategoryUseCase(categoryRepository);
    final menuApi = MenuApi();
    final menuRepository = MenuRepository(menuApi);
    final getMenuUseCase = GetMenuUseCase(menuRepository);
    final MenuApiService menuApiService = MenuApiService();
    final api = AddMenuSubcategoryApi(baseUrl: ApiConstants.baseUrl);
    final repository = AddMenuSubcategoryRepository(api: api);
    final createMenuSubcategory = CreateMenuSubcategory(repository: repository);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetCategorySubcategoryBloc(
            getCategoriesAndSubcategories: GetCategoriesAndSubcategories(
              repository: GetCategorySubcategoryRepository(
                api: GetCategorySubcategoryApi(
                  baseUrl: ApiConstants.baseUrl,
                ),
              ),
            ),
          ),
        ),
        BlocProvider<EditCategoryBloc>(
          create: (context) => EditCategoryBloc(editCategoryUseCase),
        ),
        BlocProvider(
          create: (context) => GetDishesByCategoryBloc(),
        ),
        BlocProvider<QuickSearchBloc>(
          create: (context) => QuickSearchBloc(
            repository: QuickSearchRepository(
              api: QuickSearchApi(),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => DropdownMenuCategoryBloc(
            getDropdownMenuCategories: getDropdownMenuCategories,
          ),
        ),
        BlocProvider(
          create: (context) => AddMenuSubcategoryBloc(
            createMenuSubcategory: createMenuSubcategory,
          ),
        ),
        BlocProvider<DishEditBloc>(
          create: (context) => DishEditBloc(
            repository: DishEditRepository(),
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
              MenuCategoryRepositoryImpl(
                  apiService:
                      menuApiService), // Correct way to pass the apiService
            ),
          ),
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
