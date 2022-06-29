import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_movie_recommendation_app/Features/movie_flow/genre/genre.dart';
import 'package:my_movie_recommendation_app/Features/movie_flow/movie_flow_state.dart';
import 'package:my_movie_recommendation_app/Features/movie_flow/result/movie.dart';
import 'package:my_movie_recommendation_app/Features/movie_flow/movie_service.dart';

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
  (ref) =>
      MovieFlowController(
          MovieFlowState(
              pageController: PageController(),
              movie: AsyncValue.data(Movie.initial()),
              genres: const AsyncValue.data([]),
          ),
          ref.watch(movieServiceProvider),
      ),
);

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(
      MovieFlowState state,
      this._movieService,
  ) : super(state) {
       loadGenres();
  }

  final MovieService _movieService;

  Future<void> loadGenres() async {
    state = state.copyWith(genres: const AsyncValue.loading());
    final result = await _movieService.getGenres();
    state = state.copyWith(genres: AsyncValue.data(result));
  }

  Future<void> getRecommendedMovie() async {
    state = state.copyWith(movie: const AsyncValue.loading());
    final selectedGenres = state.genres.asData?.value.where((genre) => genre.isSelected == true).toList(growable: false) ?? [];
    final result = await _movieService.getRecommendedMovie(
        state.rating,
        state.yearsBack,
        selectedGenres,
    );
    state = state.copyWith(movie: AsyncValue.data(result));
  }

  void toggleSelected(Genre genre) {
    state = state.copyWith(
      genres: AsyncValue.data([
        for (final oldGenre in state.genres.asData!.value)
          if (oldGenre == genre)
            oldGenre.toggleSelected()
          else
            oldGenre,
      ]),
    );
  }

  void updateRating(int updatedRating) {
    state = state.copyWith(rating: updatedRating);
  }

  void updateYearsBack(int updatedYearBack) {
    state = state.copyWith(yearsBack: updatedYearBack);
  }

  void nextPage() {
    if (state.pageController.page! >= 1) {
      if (!state.genres.asData!.value.any((genre) =>
      genre.isSelected == true)) {
        return;
      }
    }

    state.pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void previousPage() {
    state.pageController.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}