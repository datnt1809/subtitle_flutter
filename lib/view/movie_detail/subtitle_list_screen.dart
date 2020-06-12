import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysubtitle/bloc/subtitle_fetch_bloc.dart';
import 'package:mysubtitle/data/response/api_subtitle.dart';

import '../message.dart';

class SubtitleListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SubtitleListState();

}

class SubtitleListState extends State<SubtitleListScreen> {
  String language;
  List<String> spinnerItems =[];
  SubtitleBloc _postBloc;
  @override
  void initState() {
    _postBloc = BlocProvider.of<SubtitleBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubtitleBloc, SubtitleFetchState>(
        builder: (context, state) {
      if (state is SubtitleEmptyState) {
        return Container(
          alignment: Alignment.center,
          child: Center(
            child: SizedBox(
              width: 33,
              height: 33,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            ),
          ),
        );
      } else if (state is SubtitleErrorState) {
        return Message(message: 'Server error');
      }  else if (state is SubtitleFilterState) {
        return buildSubtitleList(state.subtitles);
      }else {
        SubtitleFetchedState fetchedState = state as SubtitleFetchedState;
        if (fetchedState.subtitles.length == 0)
          return Message(message: 'No subitles for this movie');
        else{
          if (language == null)
            language = fetchedState.language[0];
          spinnerItems.clear();
          spinnerItems.addAll(fetchedState.language);
          return buildSubtitleList(fetchedState.subtitles);
        }
      }
    });
  }

  Widget buildSubtitleList(List<Subtitle> subtitles) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: language,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black38, fontSize: 14),
              underline: Container(
                height: 2,
                color: Colors.transparent,
              ),
              onChanged: (String data) {
                _postBloc.add(SubtitleFilterEvent(language: data));
                setState(() {
                  language = data;
                });
              },
              items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, index) {
              return SubtitleWidget(subtitle: subtitles[index]);
            },
            separatorBuilder: (BuildContext context, index) {
              return Divider(
                height: 1.0,
                color: Colors.black26,
              );
            },
            itemCount: subtitles.length,
          )
        ]);
  }
}

class SubtitleWidget extends StatelessWidget {
  final Subtitle subtitle;

  const SubtitleWidget({Key key, @required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 4.0),
            child: Text(subtitle.releaseName),
          ),
          Wrap(
            spacing: 4.0,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: <Widget>[
              Icon(
                Icons.person,
                color: Colors.black45,
              ),
              Text(
                subtitle.owner,
                style: TextStyle(color: Colors.black45),
              )
            ],
          )
        ],
      ),
    );
  }
}
