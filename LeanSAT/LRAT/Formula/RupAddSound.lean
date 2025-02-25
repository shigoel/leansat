/-
Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Josh Clune
-/
import LeanSAT.LRAT.Formula.RupAddResult

open Literal

namespace LRAT
namespace DefaultFormula

open Sat DefaultClause DefaultFormula Assignment Misc ReduceResult

theorem contradiction_of_insertUnit_success {n : Nat} (assignments : Array Assignment) (assignments_size : assignments.size = n)
    (units : Array (Literal (PosFin n))) (foundContradiction : Bool) (l : Literal (PosFin n)) :
      let insertUnit_res := insertUnit (units, assignments, foundContradiction) l
      (foundContradiction → ∃ i : PosFin n, assignments[i.1]'(by rw [assignments_size]; exact i.2.2) = both) → insertUnit_res.2.2 →
      ∃ j : PosFin n, insertUnit_res.2.1[j.1]'(by rw [insertUnit_preserves_size, assignments_size]; exact j.2.2) = both := by
  intro insertUnit_res h insertUnit_success
  simp only [insertUnit_res] at *
  simp only [insertUnit] at insertUnit_success
  have l_in_bounds : l.1.1 < assignments.size := by rw [assignments_size]; exact l.1.2.2
  split at insertUnit_success
  . next hl =>
    simp only [insertUnit, hl, ite_true]
    exact h insertUnit_success
  . next hl =>
    simp only [Bool.or_eq_true] at insertUnit_success
    rcases insertUnit_success with foundContradiction_eq_true | assignments_l_ne_unassigned
    . simp only [insertUnit, hl, ite_false]
      rcases h foundContradiction_eq_true with ⟨i, h⟩
      have i_in_bounds : i.1 < assignments.size := by rw [assignments_size]; exact i.2.2
      apply Exists.intro i
      by_cases l.1.1 = i.1
      . next l_eq_i =>
        simp only [l_eq_i, Array.get_modify_at_idx i_in_bounds, h]
        exact add_of_both_eq_both l.2
      . next l_ne_i =>
        rw [Array.get_modify_unchanged i_in_bounds _ l_ne_i]
        exact h
    . apply Exists.intro l.1
      simp only [insertUnit, hl, ite_false, Array.get_modify_at_idx l_in_bounds]
      simp only [getElem!, l_in_bounds, dite_true, decidableGetElem?] at assignments_l_ne_unassigned
      by_cases l.2
      . next l_eq_true =>
        rw [l_eq_true]
        simp only [hasAssignment, l_eq_true, hasPosAssignment, getElem!, l_in_bounds, dite_true, ite_true,
          Bool.not_eq_true, decidableGetElem?] at hl
        split at hl <;> simp_all (config := { decide := true })
      . next l_eq_false =>
        simp only [Bool.not_eq_true] at l_eq_false
        rw [l_eq_false]
        simp only [hasAssignment, l_eq_false, hasNegAssignment, getElem!, l_in_bounds, dite_true, ite_false,
          Bool.not_eq_true, decidableGetElem?] at hl
        split at hl <;> simp_all (config := { decide := true })

theorem contradiction_of_insertUnit_fold_success {n : Nat} (assignments : Array Assignment) (assignments_size : assignments.size = n)
    (units : Array (Literal (PosFin n))) (foundContradiction : Bool) (l : List (Literal (PosFin n))) :
      let insertUnit_fold_res := List.foldl insertUnit (units, assignments, foundContradiction) l
      (foundContradiction → ∃ i : PosFin n, assignments[i.1]'(by rw [assignments_size]; exact i.2.2) = both) → insertUnit_fold_res.2.2 →
      ∃ j : PosFin n, insertUnit_fold_res.2.1[j.1]'(by rw [insertUnit_fold_preserves_size, assignments_size]; exact j.2.2) = both := by
  intro insertUnit_fold_res h0 insertUnit_fold_success
  let acc0 := (units, assignments, foundContradiction)
  have hb : ∃ _hsize : acc0.2.1.size = n, acc0.2.2 → ∃ j : PosFin n, acc0.2.1[j.1]'(by rw [assignments_size]; exact j.2.2) = both := by
    apply Exists.intro assignments_size
    intro foundContradiction_eq_true
    exact h0 foundContradiction_eq_true
  have hl (acc : Array (Literal (PosFin n)) × Array Assignment × Bool)
    (h : ∃ hsize : acc.2.1.size = n, acc.2.2 → ∃ j : PosFin n, acc.2.1[j.1]'(by rw [hsize]; exact j.2.2) = both)
    (l' : Literal (PosFin n)) (_ : l' ∈ l) :
    let insertUnit_res := insertUnit acc l'
    ∃ hsize : insertUnit_res.2.1.size = n,
      insertUnit_res.2.2 → ∃ j : PosFin n, insertUnit_res.2.1[j.1]'(by rw [hsize]; exact j.2.2) = both := by
    intro insertUnit_res
    have hsize : insertUnit_res.2.1.size = n := by rw [insertUnit_preserves_size, h.1]
    apply Exists.intro hsize
    intro insertUnit_res_success
    rcases h with ⟨acc_size, h⟩
    exact contradiction_of_insertUnit_success acc.2.1 acc_size acc.1 acc.2.2 l' h insertUnit_res_success
  rcases List.foldlRecOn l insertUnit acc0 hb hl with ⟨_, h⟩
  exact h insertUnit_fold_success

theorem mem_insertUnit_units {n : Nat} (units : Array (Literal (PosFin n))) (assignments : Array Assignment)
    (foundContradiction : Bool) (l : Literal (PosFin n)) :
      let insertUnit_res := insertUnit (units, assignments, foundContradiction) l
      ∀ l' : Literal (PosFin n), l' ∈ insertUnit_res.1.data → l' = l ∨ l' ∈ units.data := by
  intro insertUnit_res l' l'_in_insertUnit_res
  simp only [insertUnit_res] at *
  simp only [insertUnit] at l'_in_insertUnit_res
  split at l'_in_insertUnit_res
  . exact Or.inr l'_in_insertUnit_res
  . simp only [Array.push_data, List.mem_append, List.mem_singleton] at l'_in_insertUnit_res
    exact Or.symm l'_in_insertUnit_res

theorem mem_insertUnit_fold_units {n : Nat} (units : Array (Literal (PosFin n))) (assignments : Array Assignment)
    (foundContradiction : Bool) (l : List (Literal (PosFin n))) :
      let insertUnit_fold_res := List.foldl insertUnit (units, assignments, foundContradiction) l
      ∀ l' : Literal (PosFin n), l' ∈ insertUnit_fold_res.1.data → l' ∈ l ∨ l' ∈ units.data := by
  have hb (l' : Literal (PosFin n)) : l' ∈ (units, assignments, foundContradiction).1.data → l' ∈ l ∨ l' ∈ units.data := by
    intro h
    exact Or.inr h
  have hl (acc : Array (Literal (PosFin n)) × Array Assignment × Bool)
    (h : ∀ l' : Literal (PosFin n), l' ∈ acc.1.data → l' ∈ l ∨ l' ∈ units.data) (l'' : Literal (PosFin n))
    (l''_in_l : l'' ∈ l) : ∀ l' : Literal (PosFin n), l' ∈ (insertUnit acc l'').1.data → l' ∈ l ∨ l' ∈ units.data := by
    intro l' l'_in_res
    rcases mem_insertUnit_units  acc.1 acc.2.1 acc.2.2 l'' l' l'_in_res with l'_eq_l'' | l'_in_acc
    . rw [l'_eq_l'']
      exact Or.inl l''_in_l
    . exact h l' l'_in_acc
  exact List.foldlRecOn l insertUnit (units, assignments, foundContradiction) hb hl

theorem insertRup_entails_hsat {n : Nat} (f : DefaultFormula n) (f_readyForRupAdd : readyForRupAdd f) (c : DefaultClause n)
    (p : PosFin n → Bool) (pf : p ⊨ f) : (insertRupUnits f (negate c)).2 = true → p ⊨ c := by
  simp only [insertRupUnits]
  intro insertUnit_fold_success
  have false_imp : false → ∃ i : PosFin n, f.assignments[i.1]'(by rw [f_readyForRupAdd.2.1]; exact i.2.2) = both := by
    intro h
    simp only at h
  rcases contradiction_of_insertUnit_fold_success f.assignments f_readyForRupAdd.2.1 f.rupUnits false (negate c) false_imp
    insertUnit_fold_success with ⟨i, hboth⟩
  have i_in_bounds : i.1 < f.assignments.size := by rw [f_readyForRupAdd.2.1]; exact i.2.2
  have h0 : insertUnit_invariant f.assignments f_readyForRupAdd.2.1 f.rupUnits f.assignments f_readyForRupAdd.2.1 := by
    intro i
    simp only [Fin.getElem_fin, ne_eq, true_and, Bool.not_eq_true, exists_and_right]
    apply Or.inl
    intro j
    simp only [f_readyForRupAdd.1, Array.size_toArray, List.length_nil] at j
    exact Fin.elim0 j
  have insertUnit_fold_satisfies_invariant := insertUnit_fold_preserves_invariant f.assignments f_readyForRupAdd.2.1 f.rupUnits
    f.assignments f_readyForRupAdd.2.1 false (negate c) h0
  rcases insertUnit_fold_satisfies_invariant ⟨i.1, i.2.2⟩ with ⟨h1, h2⟩ | ⟨j, b, i_gt_zero, h1, h2, h3, h4⟩ |
    ⟨j1, j2, i_gt_zero, h1, h2, _, _, _⟩
  . rw [h1] at hboth
    simp only at hboth
    have hpos : hasAssignment true (f.assignments[i.1]'i_in_bounds) = true := by simp only [hboth]; decide
    have hneg : hasAssignment false (f.assignments[i.1]'i_in_bounds) = true := by simp only [hboth]; decide
    have p_entails_i_true := (assignments_invariant_of_strong_assignments_invariant f f_readyForRupAdd.2).2 i true hpos p pf
    have p_entails_i_false := (assignments_invariant_of_strong_assignments_invariant f f_readyForRupAdd.2).2 i false hneg p pf
    simp only [HSat.eval] at p_entails_i_true p_entails_i_false
    simp only [p_entails_i_true] at p_entails_i_false
  . simp only [HSat.eval, List.any_eq_true, Prod.exists, Bool.exists_bool, Bool.decide_coe]
    apply Exists.intro i
    have ib_in_insertUnit_fold : (i, b) ∈ (List.foldl insertUnit (f.rupUnits, f.assignments, false) (negate c)).1.data := by
      have i_rw : i = ⟨i.1, i.2⟩ := rfl
      rw [i_rw, ← h1]
      apply List.get_mem
    have ib_in_insertUnit_fold := mem_insertUnit_fold_units f.rupUnits f.assignments false (negate c) (i, b) ib_in_insertUnit_fold
    simp only [negate, negateLiteral, List.mem_map, Prod.mk.injEq, Prod.exists, Bool.exists_bool,
      Bool.not_false, Bool.not_true, f_readyForRupAdd.1, Array.data_toArray, List.find?, List.not_mem_nil, or_false]
      at ib_in_insertUnit_fold
    rw [hboth] at h2
    rcases ib_in_insertUnit_fold with ⟨i', ⟨i_false_in_c, i'_eq_i, b_eq_true⟩ | ⟨i_true_in_c, i'_eq_i, b_eq_false⟩⟩
    . apply Or.inl
      rw [i'_eq_i] at i_false_in_c
      apply And.intro i_false_in_c
      simp only [addAssignment, ← b_eq_true, addPosAssignment, ite_true] at h2
      split at h2
      . simp only at h2
      . next heq =>
        have hasNegAssignment_fi : hasAssignment false (f.assignments[i.1]'i_in_bounds) := by
          simp only [hasAssignment, hasPosAssignment, heq, ite_false]
          decide
        have p_entails_i := (assignments_invariant_of_strong_assignments_invariant f f_readyForRupAdd.2).2 i false hasNegAssignment_fi p pf
        simp only [(· ⊨ ·)] at p_entails_i
        simp only [p_entails_i, decide_True]
      . next heq =>
        exfalso
        rw [heq] at h3
        exact h3 (has_of_both b)
      . simp only at h2
    . apply Or.inr
      rw [i'_eq_i] at i_true_in_c
      apply And.intro i_true_in_c
      simp only [addAssignment, ← b_eq_false, addNegAssignment, ite_false] at h2
      split at h2
      . next heq =>
        have hasPosAssignment_fi : hasAssignment true (f.assignments[i.1]'i_in_bounds) := by
          simp only [hasAssignment, hasPosAssignment, ite_true, heq]
        have p_entails_i := (assignments_invariant_of_strong_assignments_invariant f f_readyForRupAdd.2).2 i true hasPosAssignment_fi p pf
        simp only [(· ⊨ ·)] at p_entails_i
        exact p_entails_i
      . simp only at h2
      . next heq =>
        exfalso
        rw [heq] at h3
        exact h3 (has_of_both b)
      . simp only at h2
  . exfalso
    have i_true_in_insertUnit_fold : (i, true) ∈ (List.foldl insertUnit (f.rupUnits, f.assignments, false) (negate c)).1.data := by
      have i_rw : i = ⟨i.1, i.2⟩ := rfl
      rw [i_rw, ← h1]
      apply List.get_mem
    have i_false_in_insertUnit_fold : (i, false) ∈ (List.foldl insertUnit (f.rupUnits, f.assignments, false) (negate c)).1.data := by
      have i_rw : i = ⟨i.1, i.2⟩ := rfl
      rw [i_rw, ← h2]
      apply List.get_mem
    simp only [f_readyForRupAdd.1, negate, negateLiteral] at i_true_in_insertUnit_fold i_false_in_insertUnit_fold
    have i_true_in_insertUnit_fold :=
      mem_insertUnit_fold_units #[] f.assignments false (c.clause.map negateLiteral) (i, true) i_true_in_insertUnit_fold
    have i_false_in_insertUnit_fold :=
      mem_insertUnit_fold_units #[] f.assignments false (c.clause.map negateLiteral) (i, false) i_false_in_insertUnit_fold
    simp only [negateLiteral, List.mem_map, Prod.mk.injEq, Bool.not_eq_true', Prod.exists,
      exists_eq_right_right, exists_eq_right, Array.data_toArray, List.find?, List.not_mem_nil, or_false,
      Bool.not_eq_false'] at i_true_in_insertUnit_fold i_false_in_insertUnit_fold
    have c_not_tautology := Clause.not_tautology c (i, true)
    simp only [Clause.toList, (· ⊨ ·)] at c_not_tautology
    rw [DefaultClause.toList] at c_not_tautology
    rcases c_not_tautology with i_true_not_in_c | i_false_not_in_c
    . exact i_true_not_in_c i_false_in_insertUnit_fold
    . exact i_false_not_in_c i_true_in_insertUnit_fold

theorem insertRup_entails_safe_insert {n : Nat} (f : DefaultFormula n) (f_readyForRupAdd : readyForRupAdd f)
    (c : DefaultClause n) : (insertRupUnits f (negate c)).2 = true → limplies (PosFin n) f (f.insert c) := by
  intro h p pf
  simp only [formulaHSat_def, List.all_eq_true, decide_eq_true_eq]
  intro c' c'_in_fc
  rw [insert_iff] at c'_in_fc
  rcases c'_in_fc with c'_eq_c | c'_in_f
  . rw [c'_eq_c]
    exact insertRup_entails_hsat f f_readyForRupAdd c p pf h
  . simp only [formulaHSat_def, List.all_eq_true, decide_eq_true_eq] at pf
    exact pf c' c'_in_f

theorem insertRupUnits_preserves_assignments_invariant {n : Nat} (f : DefaultFormula n) (f_readyForRupAdd : readyForRupAdd f)
    (units : List (Literal (PosFin n))) : assignments_invariant (insertRupUnits f units).1 := by
  have h := insertRupUnits_postcondition f f_readyForRupAdd units
  have hsize : (insertRupUnits f units).1.assignments.size = n := by rw [insertRupUnits_preserves_assignments_size, f_readyForRupAdd.2.1]
  apply Exists.intro hsize
  intro i b hb p hp
  simp only [(· ⊨ ·)] at hp
  simp only [toList, Array.toList_eq, List.append_assoc, List.any_eq_true, Prod.exists,
    Bool.exists_bool, Bool.decide_coe, List.all_eq_true, List.mem_append, List.mem_filterMap, id_eq,
    exists_eq_right, List.mem_map] at hp
  have pf : p ⊨ f := by
    simp only [(· ⊨ ·)]
    simp only [toList, Array.toList_eq, List.append_assoc, List.any_eq_true, Prod.exists, Bool.exists_bool,
      Bool.decide_coe, List.all_eq_true, List.mem_append, List.mem_filterMap, id_eq, exists_eq_right, List.mem_map]
    intro c cf
    rcases cf with cf | cf | cf
    . specialize hp c (Or.inl cf)
      exact hp
    . simp only [f_readyForRupAdd.1, Array.data_toArray, List.find?, List.not_mem_nil, false_and, or_self, exists_false] at cf
    . specialize hp c $ (Or.inr ∘ Or.inr) cf
      exact hp
  rcases h ⟨i.1, i.2.2⟩ with ⟨h1, h2⟩ | ⟨j, b', i_gt_zero, h1, h2, h3, h4⟩ | ⟨j1, j2, i_gt_zero, h1, h2, _, _, _⟩
  . rw [h1] at hb
    exact (assignments_invariant_of_strong_assignments_invariant f f_readyForRupAdd.2).2 i b hb p pf
  . rw [h2] at hb
    by_cases b = b'
    . next b_eq_b' =>
      let j_unit := unit (insertRupUnits f units).1.rupUnits[j]
      have j_unit_def : j_unit = unit (insertRupUnits f units).1.rupUnits[j] := rfl
      have j_unit_in_insertRupUnits_res :
        ∃ i : PosFin n,
          (i, false) ∈ (insertRupUnits f units).1.rupUnits.data ∧ unit (i, false) = j_unit ∨
          (i, true) ∈ (insertRupUnits f units).1.rupUnits.data ∧ unit (i, true) = j_unit := by
        apply Exists.intro i
        rw [j_unit_def, h1]
        by_cases hb' : b'
        . rw [hb']
          apply Or.inr
          constructor
          . have h1 : (insertRupUnits f units).fst.rupUnits[j] = (i, true) := by
              rw [hb'] at h1
              rw [h1]
              simp only [Prod.mk.injEq, and_true]
              rfl
            rw [← h1]
            apply Array.getElem_mem_data
          . rfl
        . simp only [Bool.not_eq_true] at hb'
          rw [hb']
          apply Or.inl
          constructor
          . have h1 : (insertRupUnits f units).fst.rupUnits[j] = (i, false) := by
              rw [hb'] at h1
              rw [h1]
              simp only [Prod.mk.injEq, and_true]
              rfl
            rw [← h1]
            apply Array.getElem_mem_data
          . rfl
      specialize hp j_unit ((Or.inr ∘ Or.inl) j_unit_in_insertRupUnits_res)
      simp only [List.any_eq_true, Prod.exists, Bool.exists_bool, Bool.decide_coe, Fin.getElem_fin, List.find?, j_unit] at hp
      simp only [Fin.getElem_fin] at h1
      rcases hp with ⟨i', hp⟩
      simp only [h1, Clause.toList, unit_eq, List.mem_singleton,
        Prod.mk.injEq] at hp
      rcases hp with ⟨hp1, hp2⟩ | ⟨hp1, hp2⟩
      . simp only [b_eq_b', ← hp1.2, HSat.eval]
        rw [hp1.1] at hp2
        exact of_decide_eq_true hp2
      . simp only [b_eq_b', ← hp1.2, HSat.eval]
        rw [hp1.1] at hp2
        exact hp2
    . next b_ne_b' =>
      apply (assignments_invariant_of_strong_assignments_invariant f f_readyForRupAdd.2).2 i b _ p pf
      have b'_def : b' = (decide ¬b = true) := by
        cases b <;> cases b' <;> simp at *
      rw [has_iff_has_of_add_complement, ← b'_def, hb]
  . let j1_unit := unit (insertRupUnits f units).1.rupUnits[j1]
    have j1_unit_def : j1_unit = unit (insertRupUnits f units).1.rupUnits[j1] := rfl
    have j1_unit_in_insertRupUnits_res :
      ∃ i : PosFin n,
        (i, false) ∈ (insertRupUnits f units).1.rupUnits.data ∧ unit (i, false) = j1_unit ∨
        (i, true) ∈ (insertRupUnits f units).1.rupUnits.data ∧ unit (i, true) = j1_unit := by
      apply Exists.intro i ∘ Or.inr
      rw [j1_unit_def, h1]
      constructor
      . have h1 : (insertRupUnits f units).fst.rupUnits[j1] = (i, true) := by
          rw [h1]
          simp only [Prod.mk.injEq, and_true]
          rfl
        rw [← h1]
        apply Array.getElem_mem_data
      . rfl
    let j2_unit := unit (insertRupUnits f units).1.rupUnits[j2]
    have j2_unit_def : j2_unit = unit (insertRupUnits f units).1.rupUnits[j2] := rfl
    have j2_unit_in_insertRupUnits_res :
      ∃ i : PosFin n,
        (i, false) ∈ (insertRupUnits f units).1.rupUnits.data ∧ unit (i, false) = j2_unit ∨
        (i, true) ∈ (insertRupUnits f units).1.rupUnits.data ∧ unit (i, true) = j2_unit := by
      apply Exists.intro i ∘ Or.inl
      rw [j2_unit_def, h2]
      constructor
      . have h2 : (insertRupUnits f units).fst.rupUnits[j2] = (i, false) := by
          rw [h2]
          simp only [Prod.mk.injEq, and_true]
          rfl
        rw [← h2]
        apply Array.getElem_mem_data
      . rfl
    have hp1 := hp j1_unit ((Or.inr ∘ Or.inl) j1_unit_in_insertRupUnits_res)
    have hp2 := hp j2_unit ((Or.inr ∘ Or.inl) j2_unit_in_insertRupUnits_res)
    simp only [List.any_eq_true, Prod.exists, Bool.exists_bool, Bool.decide_coe, Fin.getElem_fin, List.find?, j1_unit, j2_unit] at hp1 hp2
    rcases hp1 with ⟨i1, hp1⟩
    rcases hp2 with ⟨i2, hp2⟩
    simp only [Fin.getElem_fin] at h1
    simp only [Fin.getElem_fin] at h2
    simp only [h1, Clause.toList, unit_eq, List.mem_singleton, Prod.mk.injEq,
      and_false, false_and, and_true, false_or, h2, or_false] at hp1 hp2
    simp only [hp2.1, ← hp1.1, decide_eq_true_eq, true_and] at hp2
    simp only [hp1.2] at hp2

def confirmRupHint_fold_entails_hsat_motive {n : Nat} (f : DefaultFormula n) (_idx : Nat)
  (acc : Array Assignment × List (Literal (PosFin n)) × Bool × Bool) : Prop :=
  acc.1.size = n ∧ limplies (PosFin n) f acc.1 ∧ (acc.2.2.1 → incompatible (PosFin n) acc.1 f)

theorem encounteredBoth_entails_unsat {n : Nat} (c : DefaultClause n) (assignment : Array Assignment) :
    reduce c assignment = encounteredBoth → unsatisfiable (PosFin n) assignment := by
  have hb : (reducedToEmpty : ReduceResult (PosFin n)) = encounteredBoth → unsatisfiable (PosFin n) assignment := by
    simp only [false_implies]
  have hl (res : ReduceResult (PosFin n)) (ih : res = encounteredBoth → unsatisfiable (PosFin n) assignment)
    (l : Literal (PosFin n)) (_ : l ∈ c.clause) :
    (reduce_fold_fn assignment res l) = encounteredBoth → unsatisfiable (PosFin n) assignment := by
    intro h
    rw [reduce_fold_fn] at h
    split at h
    . exact ih rfl
    . split at h
      . split at h <;> simp at h
      . split at h <;> simp at h
      . next heq =>
        intro p hp
        simp only [(· ⊨ ·), Bool.not_eq_true] at hp
        specialize hp l.1
        simp only [heq, has_of_both] at hp
      . simp at h
    . split at h
      . split at h <;> simp at h
      . split at h <;> simp at h
      . next heq =>
        intro p hp
        simp only [(· ⊨ ·), Bool.not_eq_true] at hp
        specialize hp l.1
        simp only [heq, has_of_both] at hp
      . simp at h
    . simp at h
  exact List.foldlRecOn c.clause (reduce_fold_fn assignment) reducedToEmpty hb hl

def reduce_postcondition_induction_motive (c_arr : Array (Literal (PosFin n))) (assignment : Array Assignment)
  (idx : Nat) (res : ReduceResult (PosFin n)) : Prop :=
  (res = reducedToEmpty → ∀ (p : (PosFin n) → Bool), (∀ i : Fin c_arr.size, i.1 < idx → p ⊭ c_arr[i]) ∨ (p ⊭ assignment)) ∧
  (∀ l : Literal (PosFin n),
    res = reducedToUnit l → ∀ (p : (PosFin n) → Bool), p ⊨ assignment → (∃ i : Fin c_arr.size, i.1 < idx ∧ (p ⊨ c_arr[i])) → p ⊨ l)

theorem reduce_fold_fn_preserves_induction_motive {c_arr : Array (Literal (PosFin n))} {assignment : Array Assignment}
  (idx : Fin c_arr.size) (res : ReduceResult (PosFin n)) (ih : reduce_postcondition_induction_motive c_arr assignment idx.1 res) :
  reduce_postcondition_induction_motive c_arr assignment (idx.1 + 1) (reduce_fold_fn assignment res c_arr[idx]) := by
  simp only [reduce_postcondition_induction_motive, Fin.getElem_fin, forall_exists_index, and_imp, Prod.forall]
  constructor
  . intro h p
    rw [reduce_fold_fn] at h
    split at h
    . simp only at h
    . split at h
      . next heq =>
        split at h
        . exact False.elim h
        . next c_arr_idx_eq_false =>
          simp only [Bool.not_eq_true] at c_arr_idx_eq_false
          rcases ih.1 rfl p with ih1 | ih1
          . by_cases p ⊨ assignment
            . next p_entails_assignment =>
              apply Or.inl
              intro i i_lt_idx_add_one p_entails_c_arr_i
              rcases Nat.lt_or_eq_of_le $ Nat.le_of_lt_succ i_lt_idx_add_one with i_lt_idx | i_eq_idx
              . exact ih1 i i_lt_idx p_entails_c_arr_i
              . simp only [(· ⊨ ·), i_eq_idx, c_arr_idx_eq_false] at p_entails_c_arr_i
                simp only [(· ⊨ ·), Bool.not_eq_true] at p_entails_assignment
                specialize p_entails_assignment c_arr[idx.1].1
                simp (config := { decide := true }) only [p_entails_c_arr_i, decide_True, heq] at p_entails_assignment
            . next h =>
              exact Or.inr h
          . exact Or.inr ih1
      . next heq =>
        split at h
        . exact False.elim h
        . next c_arr_idx_eq_false =>
          simp only [Bool.not_eq_true', Bool.not_eq_false] at c_arr_idx_eq_false
          rcases ih.1 rfl p with ih1 | ih1
          . by_cases p ⊨ assignment
            . next p_entails_assignment =>
              apply Or.inl
              intro i i_lt_idx_add_one p_entails_c_arr_i
              rcases Nat.lt_or_eq_of_le $ Nat.le_of_lt_succ i_lt_idx_add_one with i_lt_idx | i_eq_idx
              . exact ih1 i i_lt_idx p_entails_c_arr_i
              . simp only [(· ⊨ ·), i_eq_idx, c_arr_idx_eq_false] at p_entails_c_arr_i
                simp only [(· ⊨ ·), Bool.not_eq_true] at p_entails_assignment
                specialize p_entails_assignment c_arr[idx.1].1
                simp (config := { decide := true }) only [p_entails_c_arr_i, decide_True, heq] at p_entails_assignment
            . next h =>
              exact Or.inr h
          . exact Or.inr ih1
      . simp only at h
      . simp only at h
    . next l =>
      split at h
      . split at h <;> contradiction
      . split at h <;> contradiction
      . simp only at h
      . simp only at h
    . simp only at h
  . intro i b h p hp j j_lt_idx_add_one p_entails_c_arr_j
    rw [reduce_fold_fn] at h
    split at h
    . simp only at h
    . split at h
      . next heq =>
        split at h
        . next c_arr_idx_eq_true =>
          simp only [reducedToUnit.injEq] at h
          simp only [h] at c_arr_idx_eq_true
          simp only [(· ⊨ ·), Bool.not_eq_true] at hp
          specialize hp c_arr[idx.val].1
          rw [heq] at hp
          by_cases p c_arr[idx.val].1
          . next p_c_arr_idx_eq_true =>
            simp only [h] at p_c_arr_idx_eq_true
            simp only [(· ⊨ ·), c_arr_idx_eq_true, p_c_arr_idx_eq_true]
          . next p_c_arr_idx_eq_false =>
            simp only [h, Bool.not_eq_true] at p_c_arr_idx_eq_false
            simp (config := { decide := true }) only [h, p_c_arr_idx_eq_false] at hp
        . exact False.elim h
      . next heq =>
        split at h
        . next c_arr_idx_eq_true =>
          simp only [reducedToUnit.injEq] at h
          simp only [h, Bool.not_eq_true'] at c_arr_idx_eq_true
          simp only [(· ⊨ ·), Bool.not_eq_true] at hp
          specialize hp c_arr[idx.val].1
          rw [heq] at hp
          by_cases p c_arr[idx.val].1
          . next p_c_arr_idx_eq_true =>
            simp only [h, Bool.not_eq_true] at p_c_arr_idx_eq_true
            simp (config := { decide := true }) only [h, p_c_arr_idx_eq_true] at hp
          . next p_c_arr_idx_eq_false =>
            simp only [h] at p_c_arr_idx_eq_false
            simp only [(· ⊨ ·), c_arr_idx_eq_true, p_c_arr_idx_eq_false]
        . exact False.elim h
      . simp only at h
      . simp only [reducedToUnit.injEq] at h
        rw [← h]
        rcases Nat.lt_or_eq_of_le $ Nat.le_of_lt_succ j_lt_idx_add_one with j_lt_idx | j_eq_idx
        . exfalso
          rcases ih.1 rfl p with ih1 | ih1
          . exact ih1 j j_lt_idx p_entails_c_arr_j
          . exact ih1 hp
        . simp only [j_eq_idx] at p_entails_c_arr_j
          exact p_entails_c_arr_j
    . next l =>
      split at h
      . next heq =>
        split at h
        . exact False.elim h
        . next c_arr_idx_eq_false =>
          simp only [Bool.not_eq_true] at c_arr_idx_eq_false
          simp only [reducedToUnit.injEq] at h
          rcases Nat.lt_or_eq_of_le $ Nat.le_of_lt_succ j_lt_idx_add_one with j_lt_idx | j_eq_idx
          . rw [← h]
            have ih2_precondition : ∃ i : Fin c_arr.size, i.val < idx.val ∧ (p ⊨ c_arr[i]) :=
              (Exists.intro j ∘ And.intro j_lt_idx) p_entails_c_arr_j
            exact ih.2 l rfl p hp ih2_precondition
          . simp only [j_eq_idx, (· ⊨ ·), c_arr_idx_eq_false] at p_entails_c_arr_j
            simp only [(· ⊨ ·), Bool.not_eq_true] at hp
            specialize hp c_arr[idx.1].1
            simp (config := { decide := true }) only [p_entails_c_arr_j, decide_True, heq] at hp
      . next heq =>
        split at h
        . exact False.elim h
        . next c_arr_idx_eq_true =>
          simp only [Bool.not_eq_true', Bool.not_eq_false] at c_arr_idx_eq_true
          simp only [reducedToUnit.injEq] at h
          rcases Nat.lt_or_eq_of_le $ Nat.le_of_lt_succ j_lt_idx_add_one with j_lt_idx | j_eq_idx
          . rw [← h]
            have ih2_precondition : ∃ i : Fin c_arr.size, i.val < idx.val ∧ (p ⊨ c_arr[i]) :=
              (Exists.intro j ∘ And.intro j_lt_idx) p_entails_c_arr_j
            exact ih.2 l rfl p hp ih2_precondition
          . simp only [j_eq_idx, (· ⊨ ·), c_arr_idx_eq_true] at p_entails_c_arr_j
            simp only [(· ⊨ ·), Bool.not_eq_true] at hp
            specialize hp c_arr[idx.1].1
            simp (config := { decide := true }) only [p_entails_c_arr_j, decide_True, heq] at hp
      . simp only at h
      . simp only at h
    . simp only at h

theorem reduce_postcondition {n : Nat} (c : DefaultClause n) (assignment : Array Assignment) :
    (reduce c assignment = reducedToEmpty → incompatible (PosFin n) c assignment) ∧
    (∀ l : Literal (PosFin n), reduce c assignment = reducedToUnit l → ∀ (p : (PosFin n) → Bool), p ⊨ assignment → p ⊨ c → p ⊨ l) := by
  let c_arr := Array.mk c.clause
  have c_clause_rw : c.clause = c_arr.data := rfl
  rw [reduce, c_clause_rw, ← Array.foldl_eq_foldl_data]
  let motive := reduce_postcondition_induction_motive c_arr assignment
  have h_base : motive 0 reducedToEmpty := by
    simp only [reduce_postcondition_induction_motive, Fin.getElem_fin, forall_exists_index, and_imp, Prod.forall,
      forall_const, false_implies, implies_true, and_true, motive]
    intro p
    apply Or.inl
    intro i i_lt_zero
    exfalso
    exact Nat.not_lt_zero i.1 i_lt_zero
  have h_inductive (idx : Fin c_arr.size) (res : ReduceResult (PosFin n)) (ih : motive idx.1 res) :
    motive (idx.1 + 1) (reduce_fold_fn assignment res c_arr[idx]) := reduce_fold_fn_preserves_induction_motive idx res ih
  rcases Array.foldl_induction motive h_base h_inductive with ⟨h1, h2⟩
  constructor
  . intro h p
    specialize h1 h p
    rcases h1 with h1 | h1
    . apply Or.inl
      intro pc
      simp only [(· ⊨ ·), List.any_eq_true, Prod.exists, Bool.exists_bool] at pc
      rcases pc with ⟨i, ⟨pc1, pc2⟩ | ⟨pc1, pc2⟩⟩
      . simp only [Clause.toList, DefaultClause.toList] at pc1
        rw [c_clause_rw] at pc1
        have idx_exists : ∃ idx : Fin c_arr.size, c_arr[idx] = (i, false) := by
          rcases List.get_of_mem pc1 with ⟨idx, hidx⟩
          rw [← Array.getElem_fin_eq_data_get] at hidx
          exact Exists.intro idx hidx
        rcases idx_exists with ⟨idx, hidx⟩
        specialize h1 idx idx.2
        rw [hidx] at h1
        exact h1 $ of_decide_eq_true pc2
      . simp only [Clause.toList, DefaultClause.toList] at pc1
        rw [c_clause_rw] at pc1
        have idx_exists : ∃ idx : Fin c_arr.size, c_arr[idx] = (i, true) := by
          rcases List.get_of_mem pc1 with ⟨idx, hidx⟩
          rw [← Array.getElem_fin_eq_data_get] at hidx
          exact Exists.intro idx hidx
        rcases idx_exists with ⟨idx, hidx⟩
        specialize h1 idx idx.2
        rw [hidx] at h1
        exact h1 $ of_decide_eq_true pc2
    . exact Or.inr h1
  . intro l hl p hp pc
    apply h2 l hl p hp
    simp only [(· ⊨ ·), List.any_eq_true, Prod.exists, Bool.exists_bool] at pc
    rcases pc with ⟨i, ⟨pc1, pc2⟩ | ⟨pc1, pc2⟩⟩
    . simp only [Clause.toList, DefaultClause.toList] at pc1
      rw [c_clause_rw] at pc1
      have idx_exists : ∃ idx : Fin c_arr.size, c_arr[idx] = (i, false) := by
        rcases List.get_of_mem pc1 with ⟨idx, hidx⟩
        rw [← Array.getElem_fin_eq_data_get] at hidx
        exact Exists.intro idx hidx
      rcases idx_exists with ⟨idx, hidx⟩
      apply Exists.intro idx ∘ And.intro idx.2
      rw [hidx]
      simp only [(· ⊨ ·)]
      exact of_decide_eq_true pc2
    . simp only [Clause.toList, DefaultClause.toList] at pc1
      rw [c_clause_rw] at pc1
      have idx_exists : ∃ idx : Fin c_arr.size, c_arr[idx] = (i, true) := by
        rcases List.get_of_mem pc1 with ⟨idx, hidx⟩
        rw [← Array.getElem_fin_eq_data_get] at hidx
        exact Exists.intro idx hidx
      rcases idx_exists with ⟨idx, hidx⟩
      apply Exists.intro idx ∘ And.intro idx.2
      rw [hidx]
      simp only [(· ⊨ ·)]
      exact of_decide_eq_true pc2

theorem reducedToEmpty_entails_incompatible {n : Nat} (c : DefaultClause n) (assignment : Array Assignment) :
  reduce c assignment = reducedToEmpty → incompatible (PosFin n) c assignment := (reduce_postcondition c assignment).1

theorem reducedToUnit_entails_limplies {n : Nat} (c : DefaultClause n) (assignment : Array Assignment) (l : Literal (PosFin n)) :
  reduce c assignment = reducedToUnit l → ∀ (p : (PosFin n) → Bool), p ⊨ assignment → p ⊨ c → p ⊨ l :=
  (reduce_postcondition c assignment).2 l

theorem confirmRupHint_preserves_motive {n : Nat} (f : DefaultFormula n) (rupHints : Array Nat) (idx : Fin rupHints.size)
    (acc : Array Assignment × List (Literal (PosFin n)) × Bool × Bool) (ih : confirmRupHint_fold_entails_hsat_motive f idx.1 acc) :
    confirmRupHint_fold_entails_hsat_motive f (idx.1 + 1) ((confirmRupHint f.clauses) acc rupHints[idx]) := by
  rcases ih with ⟨hsize, h1, h2⟩
  simp only [confirmRupHint, Bool.or_eq_true, Fin.getElem_fin]
  split
  . exact ⟨hsize, h1, h2⟩
  . next acc2_eq_false =>
    simp only [not_or, Bool.not_eq_true] at acc2_eq_false
    split
    . next c hc =>
      have c_in_f : c ∈ toList f := by
        simp only [toList, Array.toList_eq, List.append_assoc, List.mem_append, List.mem_filterMap, id_eq,
          exists_eq_right, List.mem_map, Prod.exists, Bool.exists_bool]
        apply Or.inl
        simp only [getElem?, decidableGetElem?] at hc
        split at hc
        . simp only [Option.some.injEq] at hc
          rw [← hc]
          apply Array.getElem_mem_data
        . exact False.elim hc
      split
      . next heq =>
        simp only [confirmRupHint_fold_entails_hsat_motive, h1, imp_self, and_self, hsize,
          incompatible_of_unsat (PosFin n) acc.1 f (encounteredBoth_entails_unsat c acc.1 heq)]
      . next heq =>
        simp only [confirmRupHint_fold_entails_hsat_motive, h1, hsize, forall_const, true_and]
        intro p
        rcases reducedToEmpty_entails_incompatible c acc.1 heq p with pc | pacc
        . apply Or.inr
          intro pf
          simp only [(· ⊨ ·), List.all_eq_true] at pf
          specialize pf c c_in_f
          simp only [(· ⊨ ·)] at pc
          exact pc $ of_decide_eq_true pf
        . exact Or.inl pacc
      . next l b heq =>
        simp only [confirmRupHint_fold_entails_hsat_motive]
        split
        . simp only [h1, hsize, false_implies, and_self]
        . simp only [Array.size_modify, hsize, false_implies, and_true, true_and]
          intro p pf
          have pacc := h1 p pf
          have pc : p ⊨ c := by
            simp only [(· ⊨ ·), List.all_eq_true] at pf
            exact of_decide_eq_true $ pf c c_in_f
          have plb := reducedToUnit_entails_limplies c acc.1 ⟨l, b⟩ heq p pacc pc
          simp only [(· ⊨ ·), Bool.not_eq_true]
          intro i
          specialize pacc i
          simp only [Bool.not_eq_true] at pacc
          have i_in_bounds : i.1 < acc.1.size := by rw [hsize]; exact i.2.2
          by_cases l.1 = i.1
          . next l_eq_i =>
            simp only [getElem!, Array.size_modify, i_in_bounds, ↓ reduceDIte,
              Array.get_eq_getElem, l_eq_i, Array.get_modify_at_idx i_in_bounds (addAssignment b), decidableGetElem?]
            simp only [getElem!, i_in_bounds, dite_true, Array.get_eq_getElem, decidableGetElem?] at pacc
            by_cases pi : p i
            . simp only [pi, decide_False]
              simp only [hasAssignment, pi, decide_False, ite_false] at pacc
              by_cases hb : b
              . simp only [hasAssignment, ↓reduceIte, addAssignment]
                simp only [hb]
                simp only [hasAssignment, addAssignment, hb, ite_true, ite_false, hasNeg_of_addPos]
                exact pacc
              . exfalso -- hb, pi, l_eq_i, and plb are incompatible
                simp only [Bool.not_eq_true] at hb
                simp only [(· ⊨ ·), hb, Subtype.ext l_eq_i, pi] at plb
            . simp only [Bool.not_eq_true] at pi
              simp only [pi, decide_True]
              simp only [pi, decide_True] at pacc
              by_cases hb : b
              . simp only [(· ⊨ ·), hb, Subtype.ext l_eq_i, pi] at plb
              . simp only [Bool.not_eq_true] at hb
                simp only [hasAssignment, addAssignment, hb, ite_false, ite_true, hasPos_of_addNeg]
                simp only [hasAssignment, ite_true] at pacc
                exact pacc
          . next l_ne_i =>
            simp only [getElem!, Array.size_modify, i_in_bounds,
              Array.get_modify_unchanged i_in_bounds _ l_ne_i, dite_true,
              Array.get_eq_getElem, decidableGetElem?]
            simp only [getElem!, i_in_bounds, dite_true, decidableGetElem?] at pacc
            exact pacc
      . apply And.intro hsize ∘ And.intro h1
        simp only [false_implies]
    . apply And.intro hsize ∘ And.intro h1
      simp only [false_implies]
    . apply And.intro hsize ∘ And.intro h1
      simp only [false_implies]

theorem confirmRupHint_of_insertRup_fold_entails_hsat {n : Nat} (f : DefaultFormula n) (f_readyForRupAdd : readyForRupAdd f)
    (c : DefaultClause n) (rupHints : Array Nat) (p : PosFin n → Bool) (pf : p ⊨ f) :
      let fc := insertRupUnits f (negate c)
      let confirmRupHint_fold_res := rupHints.foldl (confirmRupHint fc.1.clauses) (fc.1.assignments, [], false, false) 0 rupHints.size
      confirmRupHint_fold_res.2.2.1 = true → p ⊨ c := by
  intro fc confirmRupHint_fold_res confirmRupHint_success
  let motive := confirmRupHint_fold_entails_hsat_motive fc.1
  have h_base : motive 0 (fc.fst.assignments, [], false, false) := by
    simp only [confirmRupHint_fold_entails_hsat_motive, insertRupUnits_preserves_assignments_size, f_readyForRupAdd.2.1,
      false_implies, and_true, true_and, motive, fc]
    have fc_satisfies_assignments_invariant :=
      insertRupUnits_preserves_assignments_invariant f f_readyForRupAdd (negate c)
    exact assignments_invariant_entails_limplies fc.1 fc_satisfies_assignments_invariant
  have h_inductive (idx : Fin rupHints.size) (acc : Array Assignment × List (Literal (PosFin n)) × Bool × Bool) (ih : motive idx.1 acc) :=
    confirmRupHint_preserves_motive fc.1 rupHints idx acc ih
  rcases Array.foldl_induction motive h_base h_inductive with ⟨_, h1, h2⟩
  have fc_incompatible_confirmRupHint_fold_res := (h2 confirmRupHint_success)
  rw [incompatible.symm] at fc_incompatible_confirmRupHint_fold_res
  have fc_unsat :=
    unsat_of_limplies_and_incompatible (PosFin n) fc.1 confirmRupHint_fold_res.1 h1 fc_incompatible_confirmRupHint_fold_res p
  by_cases pc : p ⊨ c
  . exact pc
  . exfalso -- Derive contradiction from pc, pf, and fc_unsat
    simp only [(· ⊨ ·), List.any_eq_true, Prod.exists, Bool.exists_bool, not_exists, not_or,
      not_and, Bool.not_eq_true] at pc
    simp only [formulaHSat_def, List.all_eq_true, decide_eq_true_eq, Classical.not_forall,
      not_imp] at fc_unsat
    rcases fc_unsat with ⟨unsat_c, unsat_c_in_fc, p_unsat_c⟩
    have unsat_c_in_fc := mem_of_insertRupUnits f (negate c) unsat_c unsat_c_in_fc
    simp only [Array.toList_eq, List.mem_map, Misc.Prod.exists, Misc.Bool.exists_bool] at unsat_c_in_fc
    rcases unsat_c_in_fc with ⟨v, ⟨v_in_neg_c, unsat_c_eq⟩ | ⟨v_in_neg_c, unsat_c_eq⟩⟩ | unsat_c_in_f
    . simp only [negate_iff, List.mem_map, Misc.Prod.exists, Misc.Bool.exists_bool] at v_in_neg_c
      rcases v_in_neg_c with ⟨v', ⟨_, v'_eq_v⟩ | ⟨v'_in_c, v'_eq_v⟩⟩
      . simp only [negateLiteral, Bool.not_false, Prod.mk.injEq, and_false] at v'_eq_v
      . simp only [negateLiteral, Bool.not_true, Prod.mk.injEq, and_true] at v'_eq_v
        simp only [(· ⊨ ·), List.any_eq_true, decide_eq_true_eq, Misc.Prod.exists, Misc.Bool.exists_bool, ←
          unsat_c_eq, not_exists, not_or, not_and] at p_unsat_c
        specialize p_unsat_c v
        rw [Clause.unit_eq] at p_unsat_c
        simp only [List.mem_singleton, forall_const, Prod.mk.injEq, and_false, false_implies, and_true] at p_unsat_c
        simp only [(· ⊨ ·), Bool.not_eq_false] at p_unsat_c
        specialize pc v
        rw [v'_eq_v] at v'_in_c
        have pv := pc.2 v'_in_c
        simp only [(· ⊨ ·), Bool.not_eq_true] at pv
        simp only [p_unsat_c] at pv
        cases pv
    . simp only [negate_iff, List.mem_map, Misc.Prod.exists, Misc.Bool.exists_bool] at v_in_neg_c
      rcases v_in_neg_c with ⟨v', ⟨v'_in_c, v'_eq_v⟩ | ⟨_, v'_eq_v⟩⟩
      . simp only [negateLiteral, Bool.not_false, Prod.mk.injEq, and_true] at v'_eq_v
        simp only [(· ⊨ ·), List.any_eq_true, decide_eq_true_eq, Misc.Prod.exists, Misc.Bool.exists_bool, ←
          unsat_c_eq, not_exists, not_or, not_and] at p_unsat_c
        specialize p_unsat_c v
        rw [Clause.unit_eq] at p_unsat_c
        simp only [List.mem_singleton, forall_const, Prod.mk.injEq, and_false, false_implies, and_true] at p_unsat_c
        specialize pc v
        rw [v'_eq_v] at v'_in_c
        have pv := pc.1 v'_in_c
        simp only [(· ⊨ ·), Bool.not_eq_true] at pv
        simp only [p_unsat_c] at pv
        cases pv
      . simp only [negateLiteral, Bool.not_true, Prod.mk.injEq, and_false] at v'_eq_v
    . simp only [formulaHSat_def, List.all_eq_true, decide_eq_true_eq] at pf
      exact p_unsat_c $ pf unsat_c unsat_c_in_f

theorem performRupCheck_of_insertRup_entails_safe_insert {n : Nat} (f : DefaultFormula n) (f_readyForRupAdd : readyForRupAdd f)
    (c : DefaultClause n) (rupHints : Array Nat) :
      (performRupCheck (insertRupUnits f (negate c)).1 rupHints).2.2.1 = true → limplies (PosFin n) f (f.insert c) := by
  intro performRupCheck_success p pf
  simp only [performRupCheck] at performRupCheck_success
  simp only [formulaHSat_def, List.all_eq_true, decide_eq_true_eq]
  intro c' c'_in_fc
  rw [insert_iff] at c'_in_fc
  rcases c'_in_fc with c'_eq_c | c'_in_f
  . rw [c'_eq_c]
    exact confirmRupHint_of_insertRup_fold_entails_hsat f f_readyForRupAdd c rupHints p pf performRupCheck_success
  . simp only [formulaHSat_def, List.all_eq_true, decide_eq_true_eq] at pf
    exact pf c' c'_in_f

theorem rupAdd_sound {n : Nat} (f : DefaultFormula n) (c : DefaultClause n) (rupHints : Array Nat) (f' : DefaultFormula n)
    (f_readyForRupAdd : readyForRupAdd f) (rupAddSuccess : performRupAdd f c rupHints = (f', true)) : liff (PosFin n) f f' := by
  have f'_def := rupAdd_result f c rupHints f' f_readyForRupAdd rupAddSuccess
  rw [performRupAdd] at rupAddSuccess
  simp only [Bool.not_eq_true'] at rupAddSuccess
  split at rupAddSuccess
  . next insertRupContradiction =>
    intro p
    have f_limplies_fc := insertRup_entails_safe_insert f f_readyForRupAdd c insertRupContradiction p
    rw [f'_def]
    constructor
    . exact f_limplies_fc
    . exact limplies_of_insert f c p
  . split at rupAddSuccess
    . simp only [Prod.mk.injEq, and_false] at rupAddSuccess
    . split at rupAddSuccess
      . simp only [Prod.mk.injEq, and_false] at rupAddSuccess
      . next performRupCheck_success =>
        rw [Bool.not_eq_false] at performRupCheck_success
        have f_limplies_fc := performRupCheck_of_insertRup_entails_safe_insert f f_readyForRupAdd c rupHints performRupCheck_success
        rw [liff_iff_limplies_and_limplies f f', f'_def]
        constructor
        . exact f_limplies_fc
        . exact limplies_of_insert f c
