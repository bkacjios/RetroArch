/*  RetroArch - A frontend for libretro.
 *  Copyright (C) 2010-2014 - Hans-Kristian Arntzen
 *  Copyright (C) 2011-2017 - Daniel De Matteis
 *  Copyright (C) 2019-2020 - James Leaver
 *
 *  RetroArch is free software: you can redistribute it and/or modify it under the terms
 *  of the GNU General Public License as published by the Free Software Found-
 *  ation, either version 3 of the License, or (at your option) any later version.
 *
 *  RetroArch is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 *  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 *  PURPOSE.  See the GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along with RetroArch.
 *  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _DINGUX_UTILS_H
#define _DINGUX_UTILS_H

#include <retro_common_api.h>
#include <libretro.h>

#include <boolean.h>

RETRO_BEGIN_DECLS

/* Specifies all possible image filtering
 * methods when using the IPU hardware scaler
 * > Note: We do not allow 'fine tuning' of the
 *   bicubic sharpness factor, since anything
 *   other than the default value looks terrible... */
enum dingux_ipu_filter_type
{
   DINGUX_IPU_FILTER_BICUBIC = 0,
   DINGUX_IPU_FILTER_BILINEAR,
   DINGUX_IPU_FILTER_NEAREST,
   DINGUX_IPU_FILTER_LAST
};

/* Enables/disables downscaling when using
 * the IPU hardware scaler */
bool dingux_ipu_set_downscaling_enable(bool enable);

/* Sets the video scaling mode when using the
 * IPU hardware scaler
 * - keep_aspect: When 'true', aspect ratio correction
 *   (1:1 PAR) is applied. When 'false', image is
 *   stretched to full screen dimensions
 * - integer_scale: When 'true', enables integer
 *   scaling. This implicitly sets keep_aspect to
 *   'true' (since integer scaling is by definition
 *   1:1 PAR)
 * Note: OpenDingux stock firmware allows keep_aspect
 * and integer_scale to be set independently, hence
 * separate boolean values. OpenDingux beta properly
 * groups the settings into a single scaling type
 * parameter. When supporting both firmwares, it would
 * be cleaner to refactor this function to accept one
 * enum rather than 2 booleans - but this would break
 * users' existing configs, so we maintain the old
 * format... */
bool dingux_ipu_set_scaling_mode(bool keep_aspect, bool integer_scale);

/* Sets the image filtering method when
 * using the IPU hardware scaler */
bool dingux_ipu_set_filter_type(enum dingux_ipu_filter_type filter_type);

/* Resets the IPU hardware scaler to the
 * default configuration */
bool dingux_ipu_reset(void);

/* Fetches internal battery level */
int dingux_get_battery_level(void);

RETRO_END_DECLS

#endif
