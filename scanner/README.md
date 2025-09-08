# Raspberry Pi 5 + Hailo-8 Hardware Specification Report

This document summarizes the hardware specifications and critical considerations when running workloads on **Raspberry Pi 5 (Model B Rev 1.1)** combined with the **Hailo-8 NPU**.

---

## CPU
- **Model**: ARM Cortex-A76 (ARMv8-A, 64-bit)
- **Cores**: 4 cores (single-threaded)
- **Clock Range**: 1.5 GHz – 2.4 GHz
- **Cache**: L1d 256 KiB ×4, L1i 256 KiB ×4, L2 2 MiB, L3 2 MiB
- **Notes**:
  - Provides significant performance improvement over Pi 4.
  - Thermal throttling can occur; active cooling is recommended.
  - NUMA output is misleading (single NUMA domain only).

---

## GPU
- **Memory Allocation**: 4 MB (very low)
- **Core Clock**: ~500 MHz
- **Temperature**: ~49 °C
- **Notes**:
  - With only 4 MB allocated, GPU acceleration (OpenGL, camera ISP, multimedia) is effectively disabled.
  - For GPU workloads, increase allocation in `config.txt`:
    ```ini
    gpu_mem=128
    ```

---

## NPU (Hailo-8)
- **Board Name**: Hailo-8
- **Architecture**: HAILO8
- **Firmware Version**: 4.20.0 (release, extended context switch buffer)
- **Driver**: `hailo` kernel module loaded
- **Notes**:
  - Device is fully recognized and operational.
  - Ensure SDK version matches firmware 4.20.0 (see Hailo release notes).
  - Serial/part/product fields may appear as `<N/A>` (normal for HAT+ without EEPROM metadata).

---

## PCIe Link
- **Bus Address**: 0001:01:00.0
- **Capability**: PCIe Gen3 ×4
- **Active Link**: PCIe Gen3 ×1 (8 GT/s) → ~985 MB/s effective bandwidth
- **Notes**:
  - The “downgraded” status indicates device supports ×4 but Pi 5 limits it to ×1.
  - Sufficient for single 1080p@30FPS inference workloads.
  - Multi-stream or high-resolution tasks may hit bandwidth bottlenecks.

---

## ⚠️ Key Considerations
1. **CPU Stability**: Monitor and prevent thermal throttling with adequate cooling.
2. **GPU Memory Split**: Increase GPU memory if acceleration or camera features are required.
3. **NPU FW/SDK Sync**: Always match SDK to firmware 4.20.0 for stable operation.
4. **PCIe Bandwidth**: Be aware of Gen3 ×1 limitation when designing workloads.

---

