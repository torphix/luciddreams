abstract class LoadingStatus {
  const LoadingStatus();

  get exception => exception;
}

class InitialLoadingStatus extends LoadingStatus {
  const InitialLoadingStatus();
}

class LoadingInProgress extends LoadingStatus {}

class LoadingSuccess extends LoadingStatus {}

class LoadingFailed extends LoadingStatus {
  final String exception;

  LoadingFailed(this.exception);
}