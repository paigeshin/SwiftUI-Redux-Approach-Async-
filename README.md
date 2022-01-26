# SwiftUI-Redux-Approach-Async-

### Store

```swift
import Foundation
typealias Dispatcher = (Action) -> Void
typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State
typealias Middleware<StoreState: ReduxState> = (StoreState, Action, @escaping Dispatcher) -> Void
protocol ReduxState { }
struct AppState: ReduxState {
   var movies = MoviesState()
}
struct MoviesState: ReduxState {
    var movies = [Movie]()
    var selectedMovieDetail: MovieDetail?
}
protocol Action { }
struct FetchMovies: Action {
    let search: String
}
struct SetMovies: Action {
    let movies: [Movie]
}
struct FetchMovieDetails: Action {
    let imdbId: String
}
struct SetMovieDetails: Action {
    let details: MovieDetail
}
class Store<StoreState: ReduxState>: ObservableObject {
    
    var reducer: Reducer<StoreState>
    @Published var state: StoreState
    var middlewares: [Middleware<StoreState>]
    
    init(reducer: @escaping Reducer<StoreState>, state: StoreState,
         middlewares: [Middleware<StoreState>] = []) {
        self.reducer = reducer
        self.state = state
        self.middlewares = middlewares
    }
    
    func dispatch(action: Action) {
        DispatchQueue.main.async {
            self.state = self.reducer(self.state, action)
        }
        
        // run all middlewares
        middlewares.forEach { middleware in
            middleware(state, action, dispatch)
        }
    }
    
}
```

### AppReducer

```swift
import Foundation
func appReducer(_ state: AppState, _ action: Action) -> AppState {
    
    var state = state
    state.movies = moviesReducer(state.movies, action)
    return state
}
```

### MoviesReducer

```swift
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
```

### Middlewares

```swift
import Foundation
func moviesMiddleware() -> Middleware<AppState> {
    
    return { state, action, dispatch in
        
        switch action {
            case let action as FetchMovies:
                Webservice().getMoviesBy(search: action.search.urlEncode()) { result in
                    switch result {
                        case .success(let movies):
                            if let movies = movies {
                                // set movies to the state
                                dispatch(SetMovies(movies: movies))
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
                
            case let action as FetchMovieDetails:
                Webservice().getMovieDetailsBy(imdbId: action.imdbId) { result in
                    switch result {
                        case .success(let details):
                            if let details = details {
                                dispatch(SetMovieDetails(details: details))
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            default:
                break
            }
        
    }
    
}
```

### App

```swift
import SwiftUI
@main
struct HelloReduxApp: App {
    var body: some Scene {
       
        let store = Store(reducer: appReducer, state: AppState(), middlewares: [moviesMiddleware()])
        
        WindowGroup {
            ContentView().environmentObject(store)
        }
    }
}
```