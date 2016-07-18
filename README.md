A fast, data-oriented, stdlib-flavored hash table
=======

This repo contains the implementation of a fast (both for lookup and insertion) hash table, with an interface similar to that of C++ standard library collection types.

The algorithm is inspired by what's found in Apple's Objective-C runtime: rather than using the classic "tombstone" or "dummy value" approach for deleted key-value pairs, this variant always compares even deleted values in a collision sequence, however the global maximum of collision sequence lengths is stored and lookup terminates once a sequence of this length has been traversed without finding a match.

The table also expands its internal storage in chunks of powers of two, so bit twiddling can be used for modular arithmetic rather than the more expensive true integer division.

Usage
-----

	#include "hash_table.hh"

    hash_table<KeyType, ValueType> table;
    
    // an optional capacity may be specified
    // in the constructor. It need not be a power of 2.
    hash_table<KeyType, ValueType> table_with_capacity(1000);
    
    // custom hash and equality comparator function objects
    // may also be provided if necessary:
    hash_table<KeyType, ValueType, Hash, EqCmp> customized_table;
    
    // As with std::unordered_map::operator[],
    // our implementation of operator[] also
    // value-initializes non-existent entries.
    table["foo"] = "bar";
    table["qux"]; // ValueType{}
    
    // .find() for those who <3 iterators
    if (table.find("qux") == table.end()) {
        std::printf("key not found\n");
    }
    
    // and in general, there's an iterator-based API
    // begin(), end(), cbegin(), cend(), etc. all work
    for (auto &entry : table) {
        do_stuff_with(entry.key, entry.value);
    }
    
    auto it = table.find("some key");
    if (it != table.end()) {
        table.erase(it); // erase it!
    }
    
    // But my preferred interface is get*() and set():
    if (auto *valptr = table.get("foo")) {
        std::printf("found it: %s\n", valptr->c_str());
    }
    
    auto answer = table.get_or("answer", "42");
    table.remove("answer");
    
    // Of course, size() and empty() work too!
    std::size_t num_keys = table.size();
    bool is_empty = table.empty();
    
    // For debugging purposes only: load factor!
    double lf = table.load_factor();

License
-------
2-clause BSD. [if this is a problem for you, ping me and we'll find a solution. I'm no lawyer `:-)`]

TODO
----
* include some benchmarks (my experience shows that this is generally ≥5 times faster than `std::unordered_map`, depending on the exact use case.)
* tests
* maybe more/better usage examples?
* unicorns!
