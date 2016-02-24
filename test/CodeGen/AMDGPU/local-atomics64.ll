; RUN: llc -march=amdgcn -mcpu=SI -verify-machineinstrs < %s | FileCheck -strict-whitespace -check-prefix=SI -check-prefix=GCN %s
; RUN: llc -march=amdgcn -mcpu=tonga -verify-machineinstrs < %s | FileCheck -strict-whitespace -check-prefix=VI -check-prefix=GCN %s

; FUNC-LABEL: {{^}}lds_atomic_xchg_ret_i64:
; GCN: ds_wrxchg_rtn_b64
; GCN: s_endpgm
define void @lds_atomic_xchg_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw xchg i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_xchg_ret_i64_offset:
; GCN: ds_wrxchg_rtn_b64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_xchg_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw xchg i64 addrspace(3)* %gep, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_add_ret_i64:
; GCN: ds_add_rtn_u64
; GCN: s_endpgm
define void @lds_atomic_add_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw add i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_add_ret_i64_offset:
; GCN: v_mov_b32_e32 v[[LOVDATA:[0-9]+]], 9
; GCN: v_mov_b32_e32 v[[HIVDATA:[0-9]+]], 0
; SI: s_load_dword [[PTR:s[0-9]+]], s{{\[[0-9]+:[0-9]+\]}}, 0xb
; VI: s_load_dword [[PTR:s[0-9]+]], s{{\[[0-9]+:[0-9]+\]}}, 0x2c
; GCN-DAG: v_mov_b32_e32 [[VPTR:v[0-9]+]], [[PTR]]
; GCN: ds_add_rtn_u64 [[RESULT:v\[[0-9]+:[0-9]+\]]], [[VPTR]], v{{\[}}[[LOVDATA]]:[[HIVDATA]]{{\]}} offset:32
; GCN: buffer_store_dwordx2 [[RESULT]],
; GCN: s_endpgm
define void @lds_atomic_add_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i64 4
  %result = atomicrmw add i64 addrspace(3)* %gep, i64 9 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_inc_ret_i64:
; GCN: v_mov_b32_e32 v[[LOVDATA:[0-9]+]], -1
; GCN: v_mov_b32_e32 v[[HIVDATA:[0-9]+]], -1
; GCN: ds_inc_rtn_u64 [[RESULT:v\[[0-9]+:[0-9]+\]]], [[VPTR]], v{{\[}}[[LOVDATA]]:[[HIVDATA]]{{\]}}
; GCN: buffer_store_dwordx2 [[RESULT]],
; GCN: s_endpgm
define void @lds_atomic_inc_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw add i64 addrspace(3)* %ptr, i64 1 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_inc_ret_i64_offset:
; GCN: ds_inc_rtn_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_inc_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw add i64 addrspace(3)* %gep, i64 1 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_sub_ret_i64:
; GCN: ds_sub_rtn_u64
; GCN: s_endpgm
define void @lds_atomic_sub_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw sub i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_sub_ret_i64_offset:
; GCN: ds_sub_rtn_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_sub_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw sub i64 addrspace(3)* %gep, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_dec_ret_i64:
; GCN: v_mov_b32_e32 v[[LOVDATA:[0-9]+]], -1
; GCN: v_mov_b32_e32 v[[HIVDATA:[0-9]+]], -1
; GCN: ds_dec_rtn_u64 [[RESULT:v\[[0-9]+:[0-9]+\]]], [[VPTR]], v{{\[}}[[LOVDATA]]:[[HIVDATA]]{{\]}}
; GCN: buffer_store_dwordx2 [[RESULT]],
; GCN: s_endpgm
define void @lds_atomic_dec_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw sub i64 addrspace(3)* %ptr, i64 1 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_dec_ret_i64_offset:
; GCN: ds_dec_rtn_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_dec_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw sub i64 addrspace(3)* %gep, i64 1 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_and_ret_i64:
; GCN: ds_and_rtn_b64
; GCN: s_endpgm
define void @lds_atomic_and_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw and i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_and_ret_i64_offset:
; GCN: ds_and_rtn_b64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_and_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw and i64 addrspace(3)* %gep, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_or_ret_i64:
; GCN: ds_or_rtn_b64
; GCN: s_endpgm
define void @lds_atomic_or_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw or i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_or_ret_i64_offset:
; GCN: ds_or_rtn_b64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_or_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw or i64 addrspace(3)* %gep, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_xor_ret_i64:
; GCN: ds_xor_rtn_b64
; GCN: s_endpgm
define void @lds_atomic_xor_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw xor i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_xor_ret_i64_offset:
; GCN: ds_xor_rtn_b64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_xor_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw xor i64 addrspace(3)* %gep, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FIXME: There is no atomic nand instr
; XFUNC-LABEL: {{^}}lds_atomic_nand_ret_i64:uction, so we somehow need to expand this.
; define void @lds_atomic_nand_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
;   %result = atomicrmw nand i64 addrspace(3)* %ptr, i32 4 seq_cst
;   store i64 %result, i64 addrspace(1)* %out, align 8
;   ret void
; }

; FUNC-LABEL: {{^}}lds_atomic_min_ret_i64:
; GCN: ds_min_rtn_i64
; GCN: s_endpgm
define void @lds_atomic_min_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw min i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_min_ret_i64_offset:
; GCN: ds_min_rtn_i64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_min_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw min i64 addrspace(3)* %gep, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_max_ret_i64:
; GCN: ds_max_rtn_i64
; GCN: s_endpgm
define void @lds_atomic_max_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw max i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_max_ret_i64_offset:
; GCN: ds_max_rtn_i64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_max_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw max i64 addrspace(3)* %gep, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_umin_ret_i64:
; GCN: ds_min_rtn_u64
; GCN: s_endpgm
define void @lds_atomic_umin_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw umin i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_umin_ret_i64_offset:
; GCN: ds_min_rtn_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_umin_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw umin i64 addrspace(3)* %gep, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_umax_ret_i64:
; GCN: ds_max_rtn_u64
; GCN: s_endpgm
define void @lds_atomic_umax_ret_i64(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw umax i64 addrspace(3)* %ptr, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_umax_ret_i64_offset:
; GCN: ds_max_rtn_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_umax_ret_i64_offset(i64 addrspace(1)* %out, i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw umax i64 addrspace(3)* %gep, i64 4 seq_cst
  store i64 %result, i64 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_xchg_noret_i64:
; GCN: ds_wrxchg_rtn_b64
; GCN: s_endpgm
define void @lds_atomic_xchg_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw xchg i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_xchg_noret_i64_offset:
; GCN: ds_wrxchg_rtn_b64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_xchg_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw xchg i64 addrspace(3)* %gep, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_add_noret_i64:
; GCN: ds_add_u64
; GCN: s_endpgm
define void @lds_atomic_add_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw add i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_add_noret_i64_offset:
; SI: s_load_dword [[PTR:s[0-9]+]], s{{\[[0-9]+:[0-9]+\]}}, 0x9
; VI: s_load_dword [[PTR:s[0-9]+]], s{{\[[0-9]+:[0-9]+\]}}, 0x24
; GCN: v_mov_b32_e32 v[[LOVDATA:[0-9]+]], 9
; GCN: v_mov_b32_e32 v[[HIVDATA:[0-9]+]], 0
; GCN: v_mov_b32_e32 [[VPTR:v[0-9]+]], [[PTR]]
; GCN: ds_add_u64 [[VPTR]], v{{\[}}[[LOVDATA]]:[[HIVDATA]]{{\]}} offset:32
; GCN: s_endpgm
define void @lds_atomic_add_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i64 4
  %result = atomicrmw add i64 addrspace(3)* %gep, i64 9 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_inc_noret_i64:
; GCN: v_mov_b32_e32 v[[LOVDATA:[0-9]+]], -1
; GCN: v_mov_b32_e32 v[[HIVDATA:[0-9]+]], -1
; GCN: ds_inc_u64 [[VPTR]], v{{\[}}[[LOVDATA]]:[[HIVDATA]]{{\]}}
; GCN: s_endpgm
define void @lds_atomic_inc_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw add i64 addrspace(3)* %ptr, i64 1 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_inc_noret_i64_offset:
; GCN: ds_inc_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_inc_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw add i64 addrspace(3)* %gep, i64 1 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_sub_noret_i64:
; GCN: ds_sub_u64
; GCN: s_endpgm
define void @lds_atomic_sub_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw sub i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_sub_noret_i64_offset:
; GCN: ds_sub_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_sub_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw sub i64 addrspace(3)* %gep, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_dec_noret_i64:
; GCN: v_mov_b32_e32 v[[LOVDATA:[0-9]+]], -1
; GCN: v_mov_b32_e32 v[[HIVDATA:[0-9]+]], -1
; GCN: ds_dec_u64 [[VPTR]], v{{\[}}[[LOVDATA]]:[[HIVDATA]]{{\]}}
; GCN: s_endpgm
define void @lds_atomic_dec_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw sub i64 addrspace(3)* %ptr, i64 1 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_dec_noret_i64_offset:
; GCN: ds_dec_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_dec_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw sub i64 addrspace(3)* %gep, i64 1 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_and_noret_i64:
; GCN: ds_and_b64
; GCN: s_endpgm
define void @lds_atomic_and_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw and i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_and_noret_i64_offset:
; GCN: ds_and_b64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_and_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw and i64 addrspace(3)* %gep, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_or_noret_i64:
; GCN: ds_or_b64
; GCN: s_endpgm
define void @lds_atomic_or_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw or i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_or_noret_i64_offset:
; GCN: ds_or_b64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_or_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw or i64 addrspace(3)* %gep, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_xor_noret_i64:
; GCN: ds_xor_b64
; GCN: s_endpgm
define void @lds_atomic_xor_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw xor i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_xor_noret_i64_offset:
; GCN: ds_xor_b64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_xor_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw xor i64 addrspace(3)* %gep, i64 4 seq_cst
  ret void
}

; FIXME: There is no atomic nand instr
; XFUNC-LABEL: {{^}}lds_atomic_nand_noret_i64:uction, so we somehow need to expand this.
; define void @lds_atomic_nand_noret_i64(i64 addrspace(3)* %ptr) nounwind {
;   %result = atomicrmw nand i64 addrspace(3)* %ptr, i32 4 seq_cst
;   ret void
; }

; FUNC-LABEL: {{^}}lds_atomic_min_noret_i64:
; GCN: ds_min_i64
; GCN: s_endpgm
define void @lds_atomic_min_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw min i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_min_noret_i64_offset:
; GCN: ds_min_i64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_min_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw min i64 addrspace(3)* %gep, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_max_noret_i64:
; GCN: ds_max_i64
; GCN: s_endpgm
define void @lds_atomic_max_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw max i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_max_noret_i64_offset:
; GCN: ds_max_i64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_max_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw max i64 addrspace(3)* %gep, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_umin_noret_i64:
; GCN: ds_min_u64
; GCN: s_endpgm
define void @lds_atomic_umin_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw umin i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_umin_noret_i64_offset:
; GCN: ds_min_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_umin_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw umin i64 addrspace(3)* %gep, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_umax_noret_i64:
; GCN: ds_max_u64
; GCN: s_endpgm
define void @lds_atomic_umax_noret_i64(i64 addrspace(3)* %ptr) nounwind {
  %result = atomicrmw umax i64 addrspace(3)* %ptr, i64 4 seq_cst
  ret void
}

; FUNC-LABEL: {{^}}lds_atomic_umax_noret_i64_offset:
; GCN: ds_max_u64 {{.*}} offset:32
; GCN: s_endpgm
define void @lds_atomic_umax_noret_i64_offset(i64 addrspace(3)* %ptr) nounwind {
  %gep = getelementptr i64, i64 addrspace(3)* %ptr, i32 4
  %result = atomicrmw umax i64 addrspace(3)* %gep, i64 4 seq_cst
  ret void
}
