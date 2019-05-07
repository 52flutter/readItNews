import 'package:pull_to_refresh/pull_to_refresh.dart';

class StatusEvent {
  String labelId;
  RefreshStatus status;
  LoadStatus loading;
  StatusEvent(this.labelId, this.status, this.loading);
}
