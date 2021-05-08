class NotificationItem {
  final String followerUsername;
  final int userId;
  final String type; // types include liked photo, follow user, comment on photo
  final String followerImageUrl;
  final bool isFollowed;
  final bool isMention;
  final String otherUsername;
  final String otherUserProfileImageUrl;
  final String comment;
  final String commentedOrLikedOnMediaUrl;
  final String likedUsername;


 NotificationItem({
   this.followerUsername,
   this.userId,
   this.type, // types include liked photo, follow user, comment on photo
   this.followerImageUrl,
   this.isFollowed,
   this.isMention,
   this.otherUsername,
   this.otherUserProfileImageUrl,
   this.comment,
   this.commentedOrLikedOnMediaUrl,
   this.likedUsername,
 });
}

List <NotificationItem> notifs = [
  NotificationItem(
        followerUsername: 'Scooby Doo',
        userId: 1,
        type: 'comment', // types include liked photo, follow user, comment on photo
        followerImageUrl: 'assets/Dog/cuteshiba.png',
        isFollowed: true,
        isMention: false,
        otherUsername: 'Husky',
        otherUserProfileImageUrl: 'assets/Dog/doglifting.png',
        comment: 'What a lovely picture! Woof woof!',
        commentedOrLikedOnMediaUrl: 'assets/Dog/doglifting.png',
        likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'like', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cuteshiba.png',
      isFollowed: true,
      isMention: false,
      otherUsername: 'Cute Shiba',
      otherUserProfileImageUrl: 'assets/Dog/dogmask.jpg',
      comment: '',
      commentedOrLikedOnMediaUrl: 'assets/Dog/hungrydog.jpg',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'follow', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cutepug.jpg',
      isFollowed: false,
      isMention: false,
      otherUsername: 'theHungryDog',
      otherUserProfileImageUrl: '',
      comment: '',
      commentedOrLikedOnMediaUrl: '',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 1,
      type: 'comment', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cuteshiba.png',
      isFollowed: true,
      isMention: false,
      otherUsername: 'Husky',
      otherUserProfileImageUrl: 'assets/Dog/doglifting.png',
      comment: 'What a lovely picture! Woof woof!',
      commentedOrLikedOnMediaUrl: 'assets/Dog/doglifting.png',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'like', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cuteshiba.png',
      isFollowed: true,
      isMention: false,
      otherUsername: 'Cute Shiba',
      otherUserProfileImageUrl: 'assets/Dog/dogmask.jpg',
      comment: '',
      commentedOrLikedOnMediaUrl: 'assets/Dog/hungrydog.jpg',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'follow', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cutepug.jpg',
      isFollowed: false,
      isMention: false,
      otherUsername: 'theHungryDog',
      otherUserProfileImageUrl: '',
      comment: '',
      commentedOrLikedOnMediaUrl: '',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 1,
      type: 'comment', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cuteshiba.png',
      isFollowed: true,
      isMention: false,
      otherUsername: 'Husky',
      otherUserProfileImageUrl: 'assets/Dog/doglifting.png',
      comment: 'What a lovely picture! Woof woof!',
      commentedOrLikedOnMediaUrl: 'assets/Dog/doglifting.png',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'like', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cuteshiba.png',
      isFollowed: true,
      isMention: false,
      otherUsername: 'Cute Shiba',
      otherUserProfileImageUrl: 'assets/Dog/dogmask.jpg',
      comment: '',
      commentedOrLikedOnMediaUrl: 'assets/Dog/hungrydog.jpg',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'follow', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cutepug.jpg',
      isFollowed: false,
      isMention: false,
      otherUsername: 'theHungryDog',
      otherUserProfileImageUrl: '',
      comment: '',
      commentedOrLikedOnMediaUrl: '',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 1,
      type: 'comment', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cuteshiba.png',
      isFollowed: true,
      isMention: false,
      otherUsername: 'Husky',
      otherUserProfileImageUrl: 'assets/Dog/doglifting.png',
      comment: 'What a lovely picture! Woof woof!',
      commentedOrLikedOnMediaUrl: 'assets/Dog/doglifting.png',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'like', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cuteshiba.png',
      isFollowed: true,
      isMention: false,
      otherUsername: 'Cute Shiba',
      otherUserProfileImageUrl: 'assets/Dog/dogmask.jpg',
      comment: '',
      commentedOrLikedOnMediaUrl: 'assets/Dog/hungrydog.jpg',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'follow', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cutepug.jpg',
      isFollowed: false,
      isMention: false,
      otherUsername: 'theHungryDog',
      otherUserProfileImageUrl: '',
      comment: '',
      commentedOrLikedOnMediaUrl: '',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 1,
      type: 'comment', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cuteshiba.png',
      isFollowed: true,
      isMention: false,
      otherUsername: 'Husky',
      otherUserProfileImageUrl: 'assets/Dog/doglifting.png',
      comment: 'What a lovely picture! Woof woof!',
      commentedOrLikedOnMediaUrl: 'assets/Dog/doglifting.png',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'like', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cuteshiba.png',
      isFollowed: true,
      isMention: false,
      otherUsername: 'Cute Shiba',
      otherUserProfileImageUrl: 'assets/Dog/dogmask.jpg',
      comment: '',
      commentedOrLikedOnMediaUrl: 'assets/Dog/hungrydog.jpg',
      likedUsername: ''
  ),
  NotificationItem(
      followerUsername: 'Scooby Doo',
      userId: 2,
      type: 'follow', // types include liked photo, follow user, comment on photo
      followerImageUrl: 'assets/Dog/cutepug.jpg',
      isFollowed: false,
      isMention: false,
      otherUsername: 'theHungryDog',
      otherUserProfileImageUrl: '',
      comment: '',
      commentedOrLikedOnMediaUrl: '',
      likedUsername: ''
  )
];

