import LeanSAT.Tactics.BVDecide

-- Our benchmark terms are huge, no need to waste time on linting
set_option linter.all false

-- Get detailed and overall benchmarks
set_option trace.profiler true
set_option profiler true
set_option trace.sat true

namespace AIGStress

theorem t1 (_ : x = true) : (x && x) := by bv_decide
theorem t2 (_ : x = true) : ((x && x) && (x && x)) := by bv_decide
theorem t3 (_ : x = true) : (((x && x) && (x && x)) && ((x && x) && (x && x))) := by bv_decide
theorem t4 (_ : x = true) : ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) := by bv_decide
theorem t5 (_ : x = true) : (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) := by bv_decide
theorem t6 (_ : x = true) : ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) := by bv_decide
theorem t7 (_ : x = true) : (((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))) := by bv_decide
theorem t8 (_ : x = true) : ((((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))) && (((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))))) := by bv_decide
theorem t9 (_ : x = true) : (((((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))) && (((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))))) && ((((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))) && (((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))))) := by bv_decide
theorem t10 (_ : x = true) : ((((((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))) && (((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))))) && ((((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))) && (((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))))) && (((((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))) && (((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))))) && ((((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))))) && (((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))) && ((((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x))))) && (((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))) && ((((x && x) && (x && x)) && ((x && x) && (x && x))) && (((x && x) && (x && x)) && ((x && x) && (x && x)))))))))) := by bv_decide
