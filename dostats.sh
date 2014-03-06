[ $# != 1 ] && exit 1
python -c 'import pstats; pstats.Stats("test/profile'$1'.prof").strip_dirs().sort_stats("time").print_stats()' | less
python -c 'import pstats; pstats.Stats("test/profileP.prof").strip_dirs().sort_stats("time").print_callers()' | less
