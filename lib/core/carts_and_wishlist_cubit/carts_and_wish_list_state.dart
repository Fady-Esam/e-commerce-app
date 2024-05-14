class CartsAndWishListState {}

class CartsAndWishListInitial extends CartsAndWishListState {}

//? Add Carts
class CartModelSuccessAddedToCart extends CartsAndWishListState {}

class CartModelFailureAddedToCart extends CartsAndWishListState {}
//? Fetch Carts

class CartModelFailureFetchCarts extends CartsAndWishListState {
  final String errMessage;

  CartModelFailureFetchCarts({required this.errMessage});
}

class CartModelSuccessFetchCarts extends CartsAndWishListState {}

//? Update Quantity

class CartModelSuccessUpdateQuantity extends CartsAndWishListState {}


//?  Get Total
class CartModelSuccessGetTotal extends CartsAndWishListState {}
//? Remove OneCart Item

class CartModelSuccessRemoveOneItem extends CartsAndWishListState {}

//? Remove AllCarts Items

class CartModelSuccessRemovedAllItems extends CartsAndWishListState {}

//!=========================================================================================

//? Add To WishList
class WishListCubitSuccessAdded extends CartsAndWishListState {}

class WishListCubitFailedAdded extends CartsAndWishListState {

}

//? Fetch WishList

class WishListCubitFetchSuccess extends CartsAndWishListState {}

class WishListCubitFetchFailure extends CartsAndWishListState {
  final String errMessage;

  WishListCubitFetchFailure({required this.errMessage});
}

//? Remove One Item WishList

class WishListCubitRemoveOneItem extends CartsAndWishListState {}

//? Clear WishList

class WishListCubitclear extends CartsAndWishListState {}
