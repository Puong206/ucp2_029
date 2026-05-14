import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2/ui/theme/app_theme.dart';
import 'package:ucp2/ui/widgets/car_card.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<KatalogBloc>().add(FetchKatalog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('DriveEase'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(

        builder: (context, authState) {
          String userName = 'User';
          if (authState is Authenticated) {
            userName = authState.user.nama;
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang, $userName!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Temukan mobil impianmu dengan mudah',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jelajahi Katalog',
                              style: TextStyle(
                                fontFamily: 'Mont',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.surfaceColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Pilih dari berbagai pilihan kendaraan',
                              style: TextStyle(
                                fontFamily: 'Mont',
                                fontSize: 12,
                                color: AppTheme.surfaceColor
                                    .withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/katalog');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          foregroundColor: AppTheme.primaryColor,
                        ),
                        child: Text('Jelajahi'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mobil Unggulan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/katalog');
                        },
                        child: Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 14,
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                BlocBuilder<KatalogBloc, KatalogState>(
                  builder: (context, state) {
                    if (state is KatalogLoading) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      );
                    } else if (state is KatalogLoaded) {
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                        itemCount:
                            state.katalogList.length > 4 ? 4 : state.katalogList.length,
                        itemBuilder: (context, index) {
                          final katalog = state.katalogList[index];
                          return CarCard(
                            brand: katalog.brand,
                            model: katalog.model,
                            year: katalog.year,
                            imageUrl: katalog.imageUrl,
                            transmisi: katalog.transmisi,
                            kapasitas: katalog.kapasitas,
                            status: katalog.status,
                          );
                        },
                      );
                    } else if (state is KatalogError) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            'Error: ${state.message}',
                            style: TextStyle(color: AppTheme.errorColor),
                          ),
                        ),
                      );
                    }

                    return Container();
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      ), // end BlocListener
      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(
            fontFamily: 'Mont', fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'Mont', fontSize: 11),
        selectedItemColor: AppTheme.primaryColor,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.of(context).pushNamed('/katalog');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/kategori');
          } else if (index == 3) {
            context.read<AuthBloc>().add(LogoutRequested());
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental_outlined),
            activeIcon: Icon(Icons.car_rental),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_outlined),
            activeIcon: Icon(Icons.logout),
            label: 'Keluar',
          ),
        ],
      ),
    );
  }
}
