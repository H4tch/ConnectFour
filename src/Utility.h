#ifndef UTILITY_H
#define UTILITY_H

#include <memory>

/// Create a resource that knows how to deconstruct itself.
// unique_ptr requires that you give it a template argument list, since it is
// constructing an object, whereas this function can infer the types.
template<typename T>
std::unique_ptr< T >
newResource( T* instance ) {
	return std::unique_ptr< T > ( instance );
}

template<typename T, typename Destructor>
std::unique_ptr< T, Destructor >
newResource( T* instance, Destructor d ) {
	return std::unique_ptr< T, Destructor > ( instance, d );
}


template<typename T>
using PtrU = std::unique_ptr<T>;

template<typename T>
using PtrW = std::weak_ptr<T>;

template<typename T>
using PtrS = std::shared_ptr<T>;


template<typename T>
T clamp( T value, T low, T high ) {
	if ( value <= low ) { return low; }
	if ( value >= high ) { return high; }
	return value;
}



#endif //UTILITY_H

