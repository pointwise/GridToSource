#
# Copyright 2020 (c) Pointwise, Inc.
# All rights reserved.
#
# This sample Pointwise script is not supported by Pointwise, Inc.
# It is provided freely for demonstration purposes only.
# SEE THE WARRANTY DISCLAIMER AT THE BOTTOM OF THIS FILE.
#

#######################################################################
##
## Construct a source point cloud for each selected grid entity.
##
## Allows you to choose a grid entity and construct a source point
## cloud using the grid point locations.
##
## 1. Optional: Select one or more domains or blocks (initialized or empty)
## 2. Initiate script
## 3. End result is a source point cloud for each selected domain or block
##    whose point locations correspond to the grid point locations.
##
#######################################################################

package require PWI_Glyph 3

# Global spacing and decay for all new source point clouds
set ::spacing 0.1
set ::decay   0.5

## Procedures
proc getOrSelectEntities { entsVar } {
  # reflection of caller array variable
  upvar ents $entsVar

  # Define the selection mask (any domain or block)
  set selectionMask [pw::Display createSelectionMask -requireBlock {} -requireDomain {}]

  # incoming selection
  pw::Display getSelectedEntities -selectionmask $selectionMask ents

  if { 0 == [llength $ents(Domains)] && 0 == [llength $ents(Blocks)] } {
    # interactive selection
    pw::Display selectEntities -selectionmask $selectionMask -description \
      "Select domains and/or blocks for source creation" ents
  }
}

# Create a source point cloud for each input grid entity
proc createSourcePointCloud { entsVar } {
  # reflection of caller array variable
  upvar ents $entsVar

  # for each grid entity type
  foreach n [array names ents] {
    set gridEnts $ents($n)
    set sourcePts [list]
    # for each grid entity
    foreach ent $ents($n) {
      # create the point cloud
      set cloud [pw::SourcePointCloud create]
      $cloud setName "[$ent getName]_pointCloud"
      # add the source points
      for { set i 1 } { $i < [$ent getPointCount] } { incr i } {
        $cloud addPoint [$ent getXYZ $i] $::spacing $::decay
      }
    }
  }
}

## Main

# Select the domain(s) and/or block(s) and create source point cloud
array set ents [list Domains {} Blocks {}]
getOrSelectEntities ents

# Create source point cloud for each selected entity
createSourcePointCloud ents

#
# DISCLAIMER:
# TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS
# ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
# TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE, WITH REGARD TO THIS SCRIPT.  TO THE MAXIMUM EXTENT PERMITTED
# BY APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY
# FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES
# WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF
# BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE
# USE OF OR INABILITY TO USE THIS SCRIPT EVEN IF POINTWISE HAS BEEN
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE
# FAULT OR NEGLIGENCE OF POINTWISE.
#
