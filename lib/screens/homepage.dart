import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/components/calling_icon.dart';
import 'package:frs/components/webview.dart';
import 'package:frs/constants/constants.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/providers/Authentication/auth_servicec.dart';
import 'package:frs/providers/Location/location_provider.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      drawer: Drawer(
        backgroundColor: kblue,
        // width: 200,
        elevation: 2,
        child: TextButton(
          onPressed: () async {
            await ref.read(googleSignInProvider).signOut();
            Navigator.pushNamed(context, '/loginScreen');
          },
          child: Text("Logout", style: TextStyling().styleh3),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                "https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                fit: BoxFit.cover,
              ),
              Container(
                height: 260,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(65),
                          child: Image.network(
                            user!.photoURL!,
                            height: 50,
                          ),
                        ),
                        Text(user.displayName!, style: TextStyling().styleh1),
                        Text(user.email!, style: TextStyling().styleh3),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.location_city,
                                color: Colors.black,
                              ),
                              FutureBuilder<String>(
                                future: ref
                                    .read(locationPrvider)
                                    .getAddressFromCoordinates(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      'Loading',
                                      style: TextStyling()
                                          .stylep1
                                          .copyWith(color: Colors.black),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    return Text(
                                      '  ${snapshot.data}',
                                      style: TextStyling()
                                          .stylep1
                                          .copyWith(color: Colors.black),
                                    );
                                  } else {
                                    return const Text('No address found');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Text("hello ")
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10),
          //   child: FutureBuilder(
          //     future: ref.watch(weatherServiceProvider).fetchWeather(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       }

          //       if (!snapshot.hasData) {
          //         print(snapshot.data);
          //         return const Row(
          //           children: [
          //             MyCard(
          //                 text: "22*",
          //                 description: 'Temperature',
          //                 icon: Icon(
          //                   Icons.thermostat_auto_outlined,
          //                   size: 32,
          //                   color: kblue,
          //                 )),
          //             MyCard(
          //                 text: "04",
          //                 description: 'Temperature',
          //                 icon: Icon(
          //                   Icons.wind_power,
          //                   size: 32,
          //                   color: kblue,
          //                 )),
          //             MyCard(
          //                 text: "**",
          //                 description: 'Temperature',
          //                 icon: Icon(
          //                   Icons.cloud,
          //                   size: 32,
          //                   color: kblue,
          //                 )),
          //             MyCard(
          //                 text: "22*",
          //                 description: 'Temperature',
          //                 icon: Icon(
          //                   Icons.sunny,
          //                   size: 32,
          //                   color: kblue,
          //                 )),
          //           ],
          //         );
          //       } else {
          //         return Text("No data available");
          //       }
          //     },
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Card.outlined(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: Text(
                      "Emergency Contacts",
                      style: TextStyling().stylep1.copyWith(color: kblue),
                    ),
                  ),
                  const ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      CallingIcon(
                        path: "ndrf.png",
                        number: nDRF,
                        org: "NDMA",
                      ),
                      CallingIcon(
                          path: "police.png", number: police, org: "Police"),
                      CallingIcon(
                          path: "hospital.png",
                          number: ambulance,
                          org: "Hospital"),
                      CallingIcon(
                          path: "women.png", number: womenHelpline, org: "NDRF")
                    ],
                  ),
                ],
              ),
            ),
          ),
          ButtonBar(
            children: [
              IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(
                            url: "https://ashimanual.vercel.app",
                            title: "Ashish"),
                      ),
                    );
                  },
                  icon: Icon(Icons.call))
            ],
          )
        ],
      ),
    );
  }
}
