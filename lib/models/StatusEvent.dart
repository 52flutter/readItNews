import 'package:pull_to_refresh/pull_to_refresh.dart';

enum RefreshType { top, bottom }
enum RefreshResult { completed, failed, noMore }

class StatusEvent {
  seedBack(RefreshController _controller) {
    StatusEvent event = this;
    if (event.type == RefreshType.top) {
      if (event.state == RefreshResult.completed) {
        _controller.refreshCompleted();
      } else if (event.state == RefreshResult.noMore) {
        _controller.loadNoData();
      } else {
        _controller.refreshFailed();
      }
    } else {
      if (event.state == RefreshResult.completed) {
        _controller.loadComplete();
      } else if (event.state == RefreshResult.noMore) {
        _controller.loadNoData();
      } else {
        _controller.refreshFailed();
      }
    }
  }

  String labelId;
  RefreshType type;
  RefreshResult state;
  StatusEvent(this.labelId, this.type, this.state);
}
