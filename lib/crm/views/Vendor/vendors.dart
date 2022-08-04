// ignore_for_file: avoid_print, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:gms_erp/blocs/Vendor/vendor_event.dart';
import 'package:gms_erp/blocs/Vendor/vendor_state.dart';
import 'package:gms_erp/widgets/SearchField.dart';
import 'package:gms_erp/config/global_params.dart';
import 'package:gms_erp/crm/views/Client/widgets/Header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/Vendor/vendor_bloc.dart';
import '../../../inventory/views/InventoryDetails/widgets/ErrorWithRefreshButtonWidget.dart';
import '../../../widgets/ItemCard.dart';

class Vendors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BuildContext _context = context;
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => VendorBloc()..add(LoadVendors()),
      child: VendorsHome(size: size),
    );
  }
}

class VendorsHome extends StatelessWidget {
  const VendorsHome({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    BuildContext _context = context;
    return SafeArea(
        child: Scaffold(
      backgroundColor: GlobalParams.backgroundColor,
      appBar: AppBar(
        title: const Text('Fournisseurs'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: VendorsBody(size: size),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //             Navigator.push(_context,
      //                 MaterialPageRoute(builder: (context) {
      //               return BlocProvider.value(
      //                 value: BlocProvider.of<VendorBloc>(
      //                     _context),
      //    );
      //    }));
      //   },
      //   backgroundColor: Colors.white,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.blue,
      //   ),
      // ),
    ));
  }
}

class VendorsBody extends StatelessWidget {
  const VendorsBody({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    BuildContext _context = context;
    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          // Header(
          //   size: size / 1.5,
          //   // child: SearchField(
          //   //     size: size / 1.4,
          //   //     onchanged_function: (String value) {
          //   //       // BlocProvider.of<VendorBloc>(context).add(
          //   //       //   SearchClientEvent(value,
          //   //       //       BlocProvider.of<VendorBloc>(context).state.clients),
          //   //       // );
          //   //     }),
          // ),
          Expanded(
            child:
                BlocBuilder<VendorBloc, VendorState>(builder: (context, state) {
              print("request state:${state.requestState}");
              // data is loading
              if (state.requestState == RequestState.Loading ||
                  state.requestState == RequestState.Searching) {
                return Container(
                  height: size.height * 0.5,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state.requestState == RequestState.Loaded ||
                  state.requestState == RequestState.SearchLoaded) {
                return Container(
                  height: size.height * 0.78,
                  padding: EdgeInsets.only(
                      top: GlobalParams.MainPadding / 2,
                      left: GlobalParams.MainPadding / 3,
                      right: GlobalParams.MainPadding / 4),
                  child: ListView.builder(
                    itemCount: state.requestState == RequestState.Loaded
                        ? state.vendors.length
                        : state.search_result?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemCard(
                          size: size,
                          onPressed: () {},
                          var1: state.requestState == RequestState.Loaded
                              ? state.vendors[index].id
                              : state.search_result![index].id,
                          var2: state.requestState == RequestState.Loaded
                              ? state.vendors[index].vendorName1
                              : state.search_result![index].vendorName1,
                         );
                    },
                  ),
                );
              }
              // data is loaded

              // Error
              return ErrorWithRefreshButtonWidget(
                inventory: null,
                button_function: () {
                  BlocProvider.of<VendorBloc>(context).add(LoadVendors());
                },
              );
              // Error
            }),
          )
        ],
      ),
    );
  }
}