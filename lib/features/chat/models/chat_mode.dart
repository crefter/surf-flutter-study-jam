class ChatMode {
  final int index;

  const ChatMode._({required this.index});

  factory ChatMode.message() => const ChatMode._(index: 0);

  factory ChatMode.choose() => const ChatMode._(index: 1);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMode &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  int get hashCode => index.hashCode;

  ChatMode copyWith({
    int? index,
  }) {
    return ChatMode._(
      index: index ?? this.index,
    );
  }
}
