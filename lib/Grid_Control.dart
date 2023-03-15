import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

String eventTitle = "Event Title";

class GridControlTest extends StatefulWidget {
  const GridControlTest({Key? key}) : super(key: key);

  @override
  State<GridControlTest> createState() => _GridControlTestState();
}

final List<PlutoColumn> columns = <PlutoColumn>[
  PlutoColumn(
    title: 'Id',
    field: 'id',
    type: PlutoColumnType.text(),
    enableColumnDrag: false,
    // Stop position changing
    enableRowDrag: false,
    // Not to drag rows
    readOnly: true,
    // Not to change anything
    enableSorting: false,
    enableContextMenu: false,
    // Disable Menu from the side
    enableDropToResize: false,
    enableRowChecked: true,
  ),
  PlutoColumn(
    title: 'Name',
    field: 'name',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Age',
    field: 'age',
    type: PlutoColumnType.number(),
  ),
  PlutoColumn(
    title: 'Role',
    field: 'role',
    type: PlutoColumnType.select(<String>[
      'Programmer',
      'Designer',
      'Owner',
    ]),
  ),
  PlutoColumn(
    title: 'Joined',
    field: 'joined',
    type: PlutoColumnType.date(),
  ),
  PlutoColumn(
    title: 'Flag',
    field: 'flag',
    //type: PlutoColumnType.time(),
    type: PlutoColumnType.select(<String>[
      'usa',
      'ireland',
      'russia',
      'uk',
      'canada',
      'czech_republic',
    ]),
    //enableEditingMode: false,
    //readOnly: true,
    renderer: (rendererContext) {
      String flagName = "flag_usa";
      if (rendererContext.cell.value == 'usa') {
        flagName = "flag_usa";
      } else if (rendererContext.cell.value == 'ireland') {
        flagName = "flag_ireland";
      } else if (rendererContext.cell.value == 'russia') {
        flagName = "flag_russia";
      } else if (rendererContext.cell.value == 'uk') {
        flagName = "flag_uk";
      } else if (rendererContext.cell.value == 'canada') {
        flagName = "flag_canada";
      } else if (rendererContext.cell.value == 'czech_republic') {
        flagName = "flag_czech_republic";
      }
      return Container(
          margin: EdgeInsets.all(2.5), decoration: BoxDecoration(color: Colors.white54, image:DecorationImage(image: AssetImage('assets/images/$flagName.png'), fit: BoxFit.fitHeight),));
      //return Image.asset('assets/images/$flag_name.png');
    },
  ),
];

final List<PlutoRow> rows = [
  PlutoRow(
    cells: {
      'id': PlutoCell(value: 'user1'),
      'name': PlutoCell(value: 'Mike'),
      'age': PlutoCell(value: 20),
      'role': PlutoCell(value: 'Programmer'),
      'joined': PlutoCell(value: '2021-01-01'),
      'flag': PlutoCell(value: '09:00'),
    },
  ),
  PlutoRow(
    cells: {
      'id': PlutoCell(value: 'user1'),
      'name': PlutoCell(value: 'Mike'),
      'age': PlutoCell(value: 20),
      'role': PlutoCell(value: 'Programmer'),
      'joined': PlutoCell(value: '2021-01-01'),
      'flag': PlutoCell(value: '09:00'),
    },
  ),
  PlutoRow(
    cells: {
      'id': PlutoCell(value: 'user1'),
      'name': PlutoCell(value: 'Mike'),
      'age': PlutoCell(value: 20),
      'role': PlutoCell(value: 'Programmer'),
      'joined': PlutoCell(value: '2021-01-01'),
      'flag': PlutoCell(value: '09:00'),
    },
  ),
  PlutoRow(
    cells: {
      'id': PlutoCell(value: 'user1'),
      'name': PlutoCell(value: 'Mike'),
      'age': PlutoCell(value: 20),
      'role': PlutoCell(value: 'Programmer'),
      'joined': PlutoCell(value: '2021-01-01'),
      'flag': PlutoCell(value: '09:00'),
    },
  ),
  PlutoRow(
    cells: {
      'id': PlutoCell(value: 'user1'),
      'name': PlutoCell(value: 'Mike'),
      'age': PlutoCell(value: 20),
      'role': PlutoCell(value: 'Programmer'),
      'joined': PlutoCell(value: '2021-01-01'),
      'flag': PlutoCell(value: 'russia'),
    },
  ),
];

class _GridControlTestState extends State<GridControlTest> {



  @override
  Widget build(BuildContext context) {
    double? deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    double? deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    late final PlutoGridStateManager stateManager;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(50),
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                eventTitle,
                style:
                const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: PlutoGrid(
                  columns: columns,
                  rows: rows,
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    stateManager = event.stateManager;
                  },
                  onChanged: (PlutoGridOnChangedEvent event) {
                    print(event);
                  },
                  configuration: const PlutoGridConfiguration(
                    enableMoveDownAfterSelecting: false,
                    enableMoveHorizontalInEditing: false,
                    enterKeyAction: PlutoGridEnterKeyAction.toggleEditing,
                    // Enter will Stop edit and set value
                    style: PlutoGridStyleConfig(
                      // gridBackgroundColor: Colors.black,
                      // rowColor: Colors.red,
                      // evenRowColor: Colors.red,
                    ),
                    columnSize: PlutoGridColumnSizeConfig(
                        autoSizeMode: PlutoAutoSizeMode
                            .scale // FITS Columns to Screen Size
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
