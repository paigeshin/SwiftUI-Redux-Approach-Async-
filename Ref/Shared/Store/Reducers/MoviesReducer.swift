//
//  MoviesReducer.swift
//  MoviesApp
//
//  Created by Mohammad Azam on 10/11/20.
//

import Foundation

func moviesReducer(_ state: MoviesState, _ action: Action) -> MoviesState {
    var state = state
    
    switch action {
        case let action as SetMovies:
            state.movies = action.movies
        case let action as SetMovieDetails:
            state.selectedMovieDetail = action.details 
        default:
            break
    }
    
    return state 
}
