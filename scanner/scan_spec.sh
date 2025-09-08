#!/usr/bin/env bash
set -euo pipefail

# ── CPU Information ─────────────────────────────
echo "=== CPU INFO ==="
lscpu || true
echo
cat /proc/cpuinfo | grep -E "Model|processor" || true
echo

# ── GPU Information (VideoCore) ─────────────────
echo "=== GPU INFO ==="
if command -v vcgencmd &> /dev/null; then
    echo "- GPU memory allocation:"
    vcgencmd get_mem gpu || true
    echo "- GPU core clock:"
    vcgencmd measure_clock core || true
    echo "- GPU temperature:"
    vcgencmd measure_temp || true
else
    echo "vcgencmd not available"
fi
echo

if command -v glxinfo &> /dev/null; then
    echo "- OpenGL Renderer:"
    glxinfo | grep "OpenGL renderer" || true
fi
echo

# ── NPU Information (Hailo) ─────────────────────
echo "=== NPU INFO (Hailo) ==="
if command -v hailortcli &> /dev/null; then
    hailortcli device scan || true
    hailortcli fw-control identify || true
    hailortcli fw-control info || true
else
    echo "hailortcli not available"
fi
echo

# ── PCIe Link Status (Hailo) ────────────────────
echo "=== PCIe LINK INFO ==="
if command -v lspci &> /dev/null; then
    lspci -vnn | grep -A 10 -i hailo || true
    sudo lspci -vv -s 0001:01:00.0 | egrep 'LnkCap|LnkSta' || true
else
    echo "lspci not available"
fi

