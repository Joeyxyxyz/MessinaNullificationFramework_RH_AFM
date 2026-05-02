OPENQASM 2.0;
include "qelib1.inc";

// ═══════════════════════════════════════════════════════════════
// CIRCUIT 0b: DEPTH-MATCHED BASELINE — 64 QUBIT (2×4 LATTICE)
// Zero-Noise Extrapolation control circuit
//
// IDENTICAL to Circuit 3 (degeneracy) EXCEPT:
//   Step 1.5 uses CNOT-CNOT pairs (self-canceling identity)
//   instead of single CNOTs (state-copying degeneracy).
//
//   Circuit 3:  cx q[0],q[1]                → degeneracy
//   Circuit 0b: cx q[0],q[1]; cx q[0],q[1]  → identity (noise only)
//
// Same qubits touched. Same noise profile. Zero degeneracy.
// Gate count: 136 + 32 = 168 CX total (vs Circuit 3's 152)
//   → MORE noise than Circuit 3, so this is a CONSERVATIVE test.
//   → If 0b still shows stronger confinement than Circuit 3,
//      the degeneracy effect is REAL and not a noise artifact.
//
// Backend: IBM Brisbane (127-qubit) | Shots: 8061
// ═══════════════════════════════════════════════════════════════

qreg q[64];
creg c[16];

// ─── STEP 1: INITIALIZE ALL QUBITS ───
// Site (0,0): qubits 0-7
sx q[0]; sx q[1]; sx q[2]; sx q[3];
sx q[4]; sx q[5]; sx q[6]; sx q[7];
// Site (0,1): qubits 8-15
sx q[8]; sx q[9]; sx q[10]; sx q[11];
sx q[12]; sx q[13]; sx q[14]; sx q[15];
// Site (0,2): qubits 16-23
sx q[16]; sx q[17]; sx q[18]; sx q[19];
sx q[20]; sx q[21]; sx q[22]; sx q[23];
// Site (0,3): qubits 24-31
sx q[24]; sx q[25]; sx q[26]; sx q[27];
sx q[28]; sx q[29]; sx q[30]; sx q[31];
// Site (1,0): qubits 32-39
sx q[32]; sx q[33]; sx q[34]; sx q[35];
sx q[36]; sx q[37]; sx q[38]; sx q[39];
// Site (1,1): qubits 40-47
sx q[40]; sx q[41]; sx q[42]; sx q[43];
sx q[44]; sx q[45]; sx q[46]; sx q[47];
// Site (1,2): qubits 48-55
sx q[48]; sx q[49]; sx q[50]; sx q[51];
sx q[52]; sx q[53]; sx q[54]; sx q[55];
// Site (1,3): qubits 56-63
sx q[56]; sx q[57]; sx q[58]; sx q[59];
sx q[60]; sx q[61]; sx q[62]; sx q[63];

// ═══════════════════════════════════════════════════════════════
// STEP 1.5: DEPTH-MATCHED IDENTITY — ALL 8 SITES
// CNOT-CNOT pairs on SAME qubits as Circuit 3's degeneracy block.
// cx;cx = identity. Touches same qubits, same coupling noise,
// but creates ZERO degeneracy.
//
// Circuit 3 has: cx q[s],q[s+1]; cx q[s+2],q[s+3]  (2 gates/site)
// Circuit 0b:    cx;cx q[s],q[s+1]; cx;cx q[s+2],q[s+3]  (4 gates/site)
//
// Total extra CX: 32 (vs Circuit 3's 16)
// This OVERMATCHES noise → conservative control.
// ═══════════════════════════════════════════════════════════════
// Site (0,0): identity on comp 0↔1, identity on comp 2↔3
cx q[0], q[1]; cx q[0], q[1];
cx q[2], q[3]; cx q[2], q[3];
// Site (0,1)
cx q[8], q[9]; cx q[8], q[9];
cx q[10], q[11]; cx q[10], q[11];
// Site (0,2)
cx q[16], q[17]; cx q[16], q[17];
cx q[18], q[19]; cx q[18], q[19];
// Site (0,3)
cx q[24], q[25]; cx q[24], q[25];
cx q[26], q[27]; cx q[26], q[27];
// Site (1,0)
cx q[32], q[33]; cx q[32], q[33];
cx q[34], q[35]; cx q[34], q[35];
// Site (1,1)
cx q[40], q[41]; cx q[40], q[41];
cx q[42], q[43]; cx q[42], q[43];
// Site (1,2)
cx q[48], q[49]; cx q[48], q[49];
cx q[50], q[51]; cx q[50], q[51];
// Site (1,3)
cx q[56], q[57]; cx q[56], q[57];
cx q[58], q[59]; cx q[58], q[59];

barrier q[0],q[1],q[2],q[3],q[4],q[5],q[6],q[7],q[8],q[9],q[10],q[11],q[12],q[13],q[14],q[15],q[16],q[17],q[18],q[19],q[20],q[21],q[22],q[23],q[24],q[25],q[26],q[27],q[28],q[29],q[30],q[31],q[32],q[33],q[34],q[35],q[36],q[37],q[38],q[39],q[40],q[41],q[42],q[43],q[44],q[45],q[46],q[47],q[48],q[49],q[50],q[51],q[52],q[53],q[54],q[55],q[56],q[57],q[58],q[59],q[60],q[61],q[62],q[63];

// ─── STEP 2: KINETIC TERM ───
rz(pi/4) q[0]; rz(pi/4) q[1]; rz(pi/4) q[2]; rz(pi/4) q[3];
rz(pi/4) q[4]; rz(pi/4) q[5]; rz(pi/4) q[6]; rz(pi/4) q[7];
rz(pi/4) q[8]; rz(pi/4) q[9]; rz(pi/4) q[10]; rz(pi/4) q[11];
rz(pi/4) q[12]; rz(pi/4) q[13]; rz(pi/4) q[14]; rz(pi/4) q[15];
rz(pi/4) q[16]; rz(pi/4) q[17]; rz(pi/4) q[18]; rz(pi/4) q[19];
rz(pi/4) q[20]; rz(pi/4) q[21]; rz(pi/4) q[22]; rz(pi/4) q[23];
rz(pi/4) q[24]; rz(pi/4) q[25]; rz(pi/4) q[26]; rz(pi/4) q[27];
rz(pi/4) q[28]; rz(pi/4) q[29]; rz(pi/4) q[30]; rz(pi/4) q[31];
rz(pi/4) q[32]; rz(pi/4) q[33]; rz(pi/4) q[34]; rz(pi/4) q[35];
rz(pi/4) q[36]; rz(pi/4) q[37]; rz(pi/4) q[38]; rz(pi/4) q[39];
rz(pi/4) q[40]; rz(pi/4) q[41]; rz(pi/4) q[42]; rz(pi/4) q[43];
rz(pi/4) q[44]; rz(pi/4) q[45]; rz(pi/4) q[46]; rz(pi/4) q[47];
rz(pi/4) q[48]; rz(pi/4) q[49]; rz(pi/4) q[50]; rz(pi/4) q[51];
rz(pi/4) q[52]; rz(pi/4) q[53]; rz(pi/4) q[54]; rz(pi/4) q[55];
rz(pi/4) q[56]; rz(pi/4) q[57]; rz(pi/4) q[58]; rz(pi/4) q[59];
rz(pi/4) q[60]; rz(pi/4) q[61]; rz(pi/4) q[62]; rz(pi/4) q[63];

// ─── STEP 3: NEAREST-NEIGHBOR INTERACTIONS ───
// Horizontal row 0
cx q[0], q[8]; rz(0.2) q[8];
cx q[1], q[9]; rz(0.2) q[9];
cx q[2], q[10]; rz(0.2) q[10];
cx q[3], q[11]; rz(0.2) q[11];
cx q[4], q[12]; rz(0.2) q[12];
cx q[5], q[13]; rz(0.2) q[13];
cx q[6], q[14]; rz(0.2) q[14];
cx q[7], q[15]; rz(0.2) q[15];
cx q[8], q[16]; rz(0.2) q[16];
cx q[9], q[17]; rz(0.2) q[17];
cx q[10], q[18]; rz(0.2) q[18];
cx q[11], q[19]; rz(0.2) q[19];
cx q[12], q[20]; rz(0.2) q[20];
cx q[13], q[21]; rz(0.2) q[21];
cx q[14], q[22]; rz(0.2) q[22];
cx q[15], q[23]; rz(0.2) q[23];
cx q[16], q[24]; rz(0.2) q[24];
cx q[17], q[25]; rz(0.2) q[25];
cx q[18], q[26]; rz(0.2) q[26];
cx q[19], q[27]; rz(0.2) q[27];
cx q[20], q[28]; rz(0.2) q[28];
cx q[21], q[29]; rz(0.2) q[29];
cx q[22], q[30]; rz(0.2) q[30];
cx q[23], q[31]; rz(0.2) q[31];
// Horizontal row 1
cx q[32], q[40]; rz(0.2) q[40];
cx q[33], q[41]; rz(0.2) q[41];
cx q[34], q[42]; rz(0.2) q[42];
cx q[35], q[43]; rz(0.2) q[43];
cx q[36], q[44]; rz(0.2) q[44];
cx q[37], q[45]; rz(0.2) q[45];
cx q[38], q[46]; rz(0.2) q[46];
cx q[39], q[47]; rz(0.2) q[47];
cx q[40], q[48]; rz(0.2) q[48];
cx q[41], q[49]; rz(0.2) q[49];
cx q[42], q[50]; rz(0.2) q[50];
cx q[43], q[51]; rz(0.2) q[51];
cx q[44], q[52]; rz(0.2) q[52];
cx q[45], q[53]; rz(0.2) q[53];
cx q[46], q[54]; rz(0.2) q[54];
cx q[47], q[55]; rz(0.2) q[55];
cx q[48], q[56]; rz(0.2) q[56];
cx q[49], q[57]; rz(0.2) q[57];
cx q[50], q[58]; rz(0.2) q[58];
cx q[51], q[59]; rz(0.2) q[59];
cx q[52], q[60]; rz(0.2) q[60];
cx q[53], q[61]; rz(0.2) q[61];
cx q[54], q[62]; rz(0.2) q[62];
cx q[55], q[63]; rz(0.2) q[63];
// Vertical links
cx q[0], q[32]; rz(0.2) q[32];
cx q[1], q[33]; rz(0.2) q[33];
cx q[2], q[34]; rz(0.2) q[34];
cx q[3], q[35]; rz(0.2) q[35];
cx q[4], q[36]; rz(0.2) q[36];
cx q[5], q[37]; rz(0.2) q[37];
cx q[6], q[38]; rz(0.2) q[38];
cx q[7], q[39]; rz(0.2) q[39];
cx q[8], q[40]; rz(0.2) q[40];
cx q[9], q[41]; rz(0.2) q[41];
cx q[10], q[42]; rz(0.2) q[42];
cx q[11], q[43]; rz(0.2) q[43];
cx q[12], q[44]; rz(0.2) q[44];
cx q[13], q[45]; rz(0.2) q[45];
cx q[14], q[46]; rz(0.2) q[46];
cx q[15], q[47]; rz(0.2) q[47];
cx q[16], q[48]; rz(0.2) q[48];
cx q[17], q[49]; rz(0.2) q[49];
cx q[18], q[50]; rz(0.2) q[50];
cx q[19], q[51]; rz(0.2) q[51];
cx q[20], q[52]; rz(0.2) q[52];
cx q[21], q[53]; rz(0.2) q[53];
cx q[22], q[54]; rz(0.2) q[54];
cx q[23], q[55]; rz(0.2) q[55];
cx q[24], q[56]; rz(0.2) q[56];
cx q[25], q[57]; rz(0.2) q[57];
cx q[26], q[58]; rz(0.2) q[58];
cx q[27], q[59]; rz(0.2) q[59];
cx q[28], q[60]; rz(0.2) q[60];
cx q[29], q[61]; rz(0.2) q[61];
cx q[30], q[62]; rz(0.2) q[62];
cx q[31], q[63]; rz(0.2) q[63];

// ─── STEP 4: INTRA-SITE INTERACTIONS ───
// Site (0,0)
cx q[0], q[1]; rz(0.2) q[1];
cx q[2], q[3]; rz(0.2) q[3];
cx q[4], q[5]; rz(0.2) q[5];
cx q[6], q[7]; rz(0.2) q[7];
// Site (0,1)
cx q[8], q[9]; rz(0.2) q[9];
cx q[10], q[11]; rz(0.2) q[11];
cx q[12], q[13]; rz(0.2) q[13];
cx q[14], q[15]; rz(0.2) q[15];
// Site (0,2)
cx q[16], q[17]; rz(0.2) q[17];
cx q[18], q[19]; rz(0.2) q[19];
cx q[20], q[21]; rz(0.2) q[21];
cx q[22], q[23]; rz(0.2) q[23];
// Site (0,3)
cx q[24], q[25]; rz(0.2) q[25];
cx q[26], q[27]; rz(0.2) q[27];
cx q[28], q[29]; rz(0.2) q[29];
cx q[30], q[31]; rz(0.2) q[31];
// Site (1,0)
cx q[32], q[33]; rz(0.2) q[33];
cx q[34], q[35]; rz(0.2) q[35];
cx q[36], q[37]; rz(0.2) q[37];
cx q[38], q[39]; rz(0.2) q[39];
// Site (1,1)
cx q[40], q[41]; rz(0.2) q[41];
cx q[42], q[43]; rz(0.2) q[43];
cx q[44], q[45]; rz(0.2) q[45];
cx q[46], q[47]; rz(0.2) q[47];
// Site (1,2)
cx q[48], q[49]; rz(0.2) q[49];
cx q[50], q[51]; rz(0.2) q[51];
cx q[52], q[53]; rz(0.2) q[53];
cx q[54], q[55]; rz(0.2) q[55];
// Site (1,3)
cx q[56], q[57]; rz(0.2) q[57];
cx q[58], q[59]; rz(0.2) q[59];
cx q[60], q[61]; rz(0.2) q[61];
cx q[62], q[63]; rz(0.2) q[63];

// ─── STEP 5: PLAQUETTE TERMS ───
// Plaquette (0,0)-(0,1)-(1,1)-(1,0)
cx q[0], q[8]; cx q[8], q[40]; cx q[40], q[32]; cx q[32], q[0]; rz(0.75) q[0];
cx q[1], q[9]; cx q[9], q[41]; cx q[41], q[33]; cx q[33], q[1]; rz(0.75) q[1];
cx q[2], q[10]; cx q[10], q[42]; cx q[42], q[34]; cx q[34], q[2]; rz(0.75) q[2];
cx q[3], q[11]; cx q[11], q[43]; cx q[43], q[35]; cx q[35], q[3]; rz(0.75) q[3];
cx q[4], q[12]; cx q[12], q[44]; cx q[44], q[36]; cx q[36], q[4]; rz(0.75) q[4];
cx q[5], q[13]; cx q[13], q[45]; cx q[45], q[37]; cx q[37], q[5]; rz(0.75) q[5];
cx q[6], q[14]; cx q[14], q[46]; cx q[46], q[38]; cx q[38], q[6]; rz(0.75) q[6];
cx q[7], q[15]; cx q[15], q[47]; cx q[47], q[39]; cx q[39], q[7]; rz(0.75) q[7];
// Plaquette (0,1)-(0,2)-(1,2)-(1,1)
cx q[8], q[16]; cx q[16], q[48]; cx q[48], q[40]; cx q[40], q[8]; rz(0.75) q[8];
cx q[9], q[17]; cx q[17], q[49]; cx q[49], q[41]; cx q[41], q[9]; rz(0.75) q[9];
cx q[10], q[18]; cx q[18], q[50]; cx q[50], q[42]; cx q[42], q[10]; rz(0.75) q[10];
cx q[11], q[19]; cx q[19], q[51]; cx q[51], q[43]; cx q[43], q[11]; rz(0.75) q[11];
cx q[12], q[20]; cx q[20], q[52]; cx q[52], q[44]; cx q[44], q[12]; rz(0.75) q[12];
cx q[13], q[21]; cx q[21], q[53]; cx q[53], q[45]; cx q[45], q[13]; rz(0.75) q[13];
cx q[14], q[22]; cx q[22], q[54]; cx q[54], q[46]; cx q[46], q[14]; rz(0.75) q[14];
cx q[15], q[23]; cx q[23], q[55]; cx q[55], q[47]; cx q[47], q[15]; rz(0.75) q[15];
// Plaquette (0,2)-(0,3)-(1,3)-(1,2)
cx q[16], q[24]; cx q[24], q[56]; cx q[56], q[48]; cx q[48], q[16]; rz(0.75) q[16];
cx q[17], q[25]; cx q[25], q[57]; cx q[57], q[49]; cx q[49], q[17]; rz(0.75) q[17];
cx q[18], q[26]; cx q[26], q[58]; cx q[58], q[50]; cx q[50], q[18]; rz(0.75) q[18];
cx q[19], q[27]; cx q[27], q[59]; cx q[59], q[51]; cx q[51], q[19]; rz(0.75) q[19];
cx q[20], q[28]; cx q[28], q[60]; cx q[60], q[52]; cx q[52], q[20]; rz(0.75) q[20];
cx q[21], q[29]; cx q[29], q[61]; cx q[61], q[53]; cx q[53], q[21]; rz(0.75) q[21];
cx q[22], q[30]; cx q[30], q[62]; cx q[62], q[54]; cx q[54], q[22]; rz(0.75) q[22];
cx q[23], q[31]; cx q[31], q[63]; cx q[63], q[55]; cx q[55], q[23]; rz(0.75) q[23];

// ─── MEASUREMENT: SUBSET ONLY ───
// Site (0,0): qubits 0-7 → c[0]-c[7]
measure q[0] -> c[0];
measure q[1] -> c[1];
measure q[2] -> c[2];
measure q[3] -> c[3];
measure q[4] -> c[4];
measure q[5] -> c[5];
measure q[6] -> c[6];
measure q[7] -> c[7];
// Site (1,0): qubits 32-39 → c[8]-c[15]
measure q[32] -> c[8];
measure q[33] -> c[9];
measure q[34] -> c[10];
measure q[35] -> c[11];
measure q[36] -> c[12];
measure q[37] -> c[13];
measure q[38] -> c[14];
measure q[39] -> c[15];
