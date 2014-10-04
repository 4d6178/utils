#include <iterator>
#include <type_traits>

/**
 * Non-member `rbegin` and `rend` functions that can be used both with containers
 * and C-style arrays.
 */

template <typename T,
         bool _IsArray = std::is_array<T>::value,
         bool _IsConst = std::is_const<T>::value>
struct __iterator_type_selector;

template <typename T>
struct __iterator_type_selector<T, true, false>
{
    using value_type = typename std::decay<T>::type;
};

template <typename T>
struct __iterator_type_selector<T, true, true>
{
    using value_type = typename std::decay<T>::type;
};

template <typename T>
struct __iterator_type_selector<T, false, false>
{
    using value_type = typename T::iterator;
};

template <typename T>
struct __iterator_type_selector<T, false, true>
{
    using value_type = typename T::const_iterator;
};

template <typename Container>
auto rbegin(Container &c)
    -> decltype(std::reverse_iterator<typename __iterator_type_selector<Container>::value_type>(std::end(c)))
{
    using value_type = typename __iterator_type_selector<Container>::value_type;
    return std::reverse_iterator<value_type>(std::end(c));
}

template <typename Container>
auto rend(Container &c)
    -> decltype(std::reverse_iterator<typename __iterator_type_selector<Container>::value_type>(std::begin(c)))
{
    using value_type = typename __iterator_type_selector<Container>::value_type;
    return std::reverse_iterator<value_type>(std::begin(c));
}

template <typename Container>
auto rbegin(const Container &c)
    -> decltype(std::reverse_iterator<typename __iterator_type_selector<Container>::value_type>(std::end(c)))
{
    using value_type = typename __iterator_type_selector<Container>::value_type;
    return std::reverse_iterator<value_type>(cend(c));
}

template <typename Container>
auto rend(const Container &c)
    -> decltype(std::reverse_iterator<typename __iterator_type_selector<Container>::value_type>(std::begin(c)))
{
    using value_type = typename __iterator_type_selector<Container>::value_type;
    return std::reverse_iterator<value_type>(std::begin(c));
}
