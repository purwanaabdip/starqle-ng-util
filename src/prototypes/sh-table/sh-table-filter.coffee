# =============================================================================
# Copyright (c) 2015 All Right Reserved, http://starqle.com/
#
# This source is subject to the Starqle Permissive License.
# Please see the License.txt file for more information.
# All other rights reserved.
#
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
# KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
# PARTICULAR PURPOSE.
#
# @file_name src/prototypes/sh-table/sh-table-filter.coffee
# @author Raymond Ralibi
# @email ralibi@starqle.com
# @company PT. Starqle Indonesia
# @note This file contains prototype for table filter
# =============================================================================

"use strict"

shTableModule.run ['$rootScope', ($rootScope) ->


  ###*
  # @ngdoc factory
  # @name shTableHelper
  #
  # @description
  # shTableHelper
  ###
  $rootScope.shTableFilter = [
    '$filter'
    '$injector'
    '$rootScope'
    'HelperService'
    (
      $filter
      $injector
      $rootScope
      HelperService
    ) ->

      self = this

      @filterParams = {} unless @filterParams?
      @filterRegion =
        visible: true # show filter by default


      @form = {}

      #
      # Injection
      #
      $injector.invoke $rootScope.shForm, @form

      # =========================================================================
      # Date filters
      # =========================================================================

      # @filterDateAnyday = (shFilter) ->
      #   $.extend @filterParams,
      #     shFilter

      dateParams = {}
      @filterLabel = {}
      @filterCollection = {}

      @prepareFilterDate = (shFilter) ->
        dateParams = {}
        delete @filterParams[shFilter+"_eqdate"]
        delete @filterParams[shFilter+"_lteqdate"]
        delete @filterParams[shFilter+"_gteqdate"]

      @executeFilterDate = () ->
        $.extend @filterParams, dateParams
        @tableParams.$params.pageNumber = 1
        @refreshGrid()

      @filterDateLabel = (keyword, shFilter, n) ->
        switch keyword
          when 'ANY'
            $filter('translate')('LABEL_ALL')

          when 'TODAY'
            $filter('translate')('LABEL_TODAY')

          when 'PAST_N_DAYS'
            $filter('translate')('LABEL_FROM') + ' ' +
            if n is 1
              $filter('translate')('LABEL_YESTERDAY')
            else
              moment().subtract(n, 'days').fromNow()

          when 'PAST_N_WEEKS'
            $filter('translate')('LABEL_FROM') + ' ' +
            moment().subtract(n, 'weeks').fromNow()

          when 'PAST_N_MONTHS'
            $filter('translate')('LABEL_FROM') + ' ' +
            moment().subtract(n, 'months').fromNow()

          when 'PAST_N_YEARS'
            $filter('translate')('LABEL_FROM') + ' ' +
            moment().subtract(n, 'years').fromNow()

          when 'NEXT_N_DAYS'
            if n is 1
              $filter('translate')('LABEL_THRU') + ' ' +
              $filter('translate')('LABEL_TOMORROW')
            else
              moment().add(n, 'days').fromNow() + ' ' +
              $filter('translate')('LABEL_AHEAD')

          when 'NEXT_N_WEEKS'
            moment().add(n, 'weeks').fromNow() + ' ' +
            $filter('translate')('LABEL_AHEAD')

          when 'NEXT_N_MONTHS'
            moment().add(n, 'months').fromNow() + ' ' +
            $filter('translate')('LABEL_AHEAD')

          when 'NEXT_N_YEARS'
            moment().add(n, 'years').fromNow() + ' ' +
            $filter('translate')('LABEL_AHEAD')

      @filterDate = (keyword, shFilter, n) ->
        if keyword in ['RANGE', 'CERTAIN']
          switch keyword
            when 'RANGE'
              fromDate = @filterParams[shFilter+"_gteqdate"]
              thruDate = @filterParams[shFilter+"_lteqdate"]
              @prepareFilterDate(shFilter)
              @filterDateRange(shFilter, fromDate, thruDate)
              @filterLabel[shFilter] = moment(fromDate).format('DD-MM-YYYY')+' - '+moment(thruDate).format('DD-MM-YYYY')
            when 'CERTAIN'
              fromDate = @filterParams[shFilter+"_gteqdate"]
              thruDate = fromDate
              @prepareFilterDate(shFilter)
              @filterDateRange(shFilter, fromDate, thruDate)
              @filterLabel[shFilter] = moment(fromDate).format('DD-MM-YYYY')

        else
          @prepareFilterDate(shFilter)
          switch keyword
            when 'ANY'
              @filterDateAny(shFilter)
            when 'TODAY'
              @filterDateToday(shFilter)

            when 'PAST_N_DAYS'
              @filterDatePastNDays(shFilter, n)
            when 'PAST_N_WEEKS'
              @filterDatePastNWeeks(shFilter, n)
            when 'PAST_N_MONTHS'
              @filterDatePastNMonths(shFilter, n)
            when 'PAST_N_YEARS'
              @filterDatePastNYears(shFilter, n)

            when 'NEXT_N_DAYS'
              @filterDateNextNDays(shFilter, n)
            when 'NEXT_N_WEEKS'
              @filterDateNextNWeeks(shFilter, n)
            when 'NEXT_N_MONTHS'
              @filterDateNextNMonths(shFilter, n)
            when 'NEXT_N_YEARS'
              @filterDateNextNYears(shFilter, n)

          @filterLabel[shFilter] = @filterDateLabel(keyword, shFilter, n)

        @executeFilterDate()


      @filterDateAny = (shFilter) ->
        ### ###

      @filterDateToday = (shFilter) ->
        dateParams[shFilter+"_eqdate"] = moment().format('YYYY-MM-DD')


      @filterDatePastNDays = (shFilter, n) ->
        dateParams[shFilter+"_lteqdate"] = moment().format('YYYY-MM-DD')
        dateParams[shFilter+"_gteqdate"] = moment().subtract(n, 'days').format('YYYY-MM-DD')

      @filterDatePastNWeeks = (shFilter, n) ->
        dateParams[shFilter+"_lteqdate"] = moment().format('YYYY-MM-DD')
        dateParams[shFilter+"_gteqdate"] = moment().subtract(n, 'weeks').format('YYYY-MM-DD')

      @filterDatePastNMonths = (shFilter, n) ->
        dateParams[shFilter+"_lteqdate"] = moment().format('YYYY-MM-DD')
        dateParams[shFilter+"_gteqdate"] = moment().subtract(n, 'months').format('YYYY-MM-DD')

      @filterDatePastNYears = (shFilter, n) ->
        dateParams[shFilter+"_lteqdate"] = moment().format('YYYY-MM-DD')
        dateParams[shFilter+"_gteqdate"] = moment().subtract(n, 'years').format('YYYY-MM-DD')


      @filterDateNextNDays = (shFilter, n) ->
        dateParams[shFilter+"_lteqdate"] = moment().add(n, 'days').format('YYYY-MM-DD')
        dateParams[shFilter+"_gteqdate"] = moment().format('YYYY-MM-DD')

      @filterDateNextNWeeks = (shFilter, n) ->
        dateParams[shFilter+"_lteqdate"] = moment().add(n, 'weeks').format('YYYY-MM-DD')
        dateParams[shFilter+"_gteqdate"] = moment().format('YYYY-MM-DD')

      @filterDateNextNMonths = (shFilter, n) ->
        dateParams[shFilter+"_lteqdate"] = moment().add(n, 'months').format('YYYY-MM-DD')
        dateParams[shFilter+"_gteqdate"] = moment().format('YYYY-MM-DD')

      @filterDateNextNYears = (shFilter, n) ->
        dateParams[shFilter+"_lteqdate"] = moment().add(n, 'years').format('YYYY-MM-DD')
        dateParams[shFilter+"_gteqdate"] = moment().format('YYYY-MM-DD')


      @filterDateRange = (shFilter, fromDate, thruDate) ->
        dateParams[shFilter+"_gteqdate"] = fromDate
        dateParams[shFilter+"_lteqdate"] = thruDate


      @getLabelDateSpecific = (shFilter) ->
        # empty space ('') is not the same with null
        @filterParams[shFilter+"_eqdate"] or null

      @openDateFilterModal = (shFilter) ->
        angular.element("#date-filter-#{shFilter}-modal").modal('show')
        return



      # =========================================================================
      # Number filters
      # =========================================================================

      numberParams = {}

      @prepareFilterNumber = (shFilter) ->
        numberParams = {}
        delete @filterParams[shFilter+"_eq"]
        delete @filterParams[shFilter+"_lteq"]
        delete @filterParams[shFilter+"_gteq"]

      @executeFilterNumber = () ->
        $.extend @filterParams, numberParams
        @tableParams.$params.pageNumber = 1
        @refreshGrid()

      @filterNumberAny = (shFilter) ->
        console.log '@filterNumberAny', shFilter
        @prepareFilterNumber(shFilter)
        @executeFilterNumber()

      @filterNumberSpecific = (shFilter, number) ->
        console.log '@filterNumberSpecific', number
        @prepareFilterNumber(shFilter)
        numberParams[shFilter+"_eq"] = number unless (number is null or number is undefined)
        @executeFilterNumber()

      @filterNumberRange = (shFilter, leftNumber, rightNumber) ->
        console.log '@filterNumberRange', shFilter, leftNumber, rightNumber
        @prepareFilterNumber(shFilter)
        numberParams[shFilter+"_gteq"] = leftNumber unless (leftNumber is null or leftNumber is undefined)
        numberParams[shFilter+"_lteq"] = rightNumber unless (rightNumber is null or rightNumber is undefined)
        @executeFilterNumber()

      @getLabelNumberRange = (shFilter, leftNumber, rightNumber) ->
        if (not (leftNumber is null or leftNumber is undefined) and not (rightNumber is null or rightNumber is undefined))
          $filter('number')(leftNumber) + ' - ' + $filter('number')(rightNumber)
        else if (not (leftNumber is null or leftNumber is undefined))
          '> ' + $filter('number')(leftNumber)
        else if (not (rightNumber is null or rightNumber is undefined))
          '< ' + $filter('number')(rightNumber)
        else
          null

      @getLabelNumberSpecific = (shFilter) ->
        # empty space ('') is not the same with null
        @filterParams[shFilter+"_eq"] or null

      @openNumberFilterModal = (shFilter) ->
        angular.element("#number-filter-#{shFilter}-modal").modal('show')
        return



      # =========================================================================
      # Text filters
      # =========================================================================

      @filterTextCont = (shFilter) ->
        console.log 'bar'
        @tableParams.$params.pageNumber = 1
        @refreshGrid()

      @getLabelTextCont = (shFilter) ->
        # empty space ('') is not the same with null
        @filterParams[shFilter+"_cont"] or null

      # =========================================================================
      @filterYearBetween = (shFilter, year) ->
        @filterParams[shFilter + '_month'] = null
        @filterParams[shFilter + '_year'] = year
        @filterParams[shFilter + '_lteqdate'] = year + '-12-31'
        @filterParams[shFilter + '_gteqdate'] = year + '-01-01'
        @refreshGrid()

      @filterMonthBetween = (shFilter, month) ->
        console.log 'month', month
        if @filterParams[shFilter + '_year']
          year = @filterParams[shFilter + '_year']
          month = ('00' + month).slice(-2)
          @filterParams[shFilter + '_month'] = month
          mDate = moment(year + '-' + month + '-01')
          @filterParams[shFilter + '_lteqdate'] = mDate.endOf('month').format('YYYY-MM-DD')
          @filterParams[shFilter + '_gteqdate'] = mDate.startOf('month').format('YYYY-MM-DD')
        @refreshGrid()



      # =========================================================================
      # Collection filters
      # =========================================================================

      @filterInCollection = (shFilter, key = null) ->
        if key?
          @filterLabel[shFilter] = @filterCollection[shFilter].map(
            (o) -> $filter('translate') o[key + ''] ).join(', ')
          @filterParams[shFilter + '_in'] =
          @filterCollection[shFilter].map( (o) -> o[key + ''] )
        else
          @filterLabel[shFilter] = @filterCollection[shFilter].map(
            (o) -> $filter('translate') o
          ).join(', ')
          @filterParams[shFilter + '_in'] = @filterCollection[shFilter]
        @refreshGrid()

      @collectionNavbarFilterSelect = (shFilter, item, key = null) ->
        @filterCollection[shFilter] = [] unless @filterCollection[shFilter]?
        HelperService.rowSelect(item, @filterCollection[shFilter], key)
        @filterInCollection(shFilter, key)

      @collectionNavbarFilterDeselect = (shFilter, item, key = null) ->
        @filterCollection[shFilter] = [] unless @filterCollection[shFilter]?
        HelperService.rowDeselect(item, @filterCollection[shFilter], key)
        @filterInCollection(shFilter, key)

      @collectionNavbarFilterIsSelected = (shFilter, item, key = null) ->
        @filterCollection[shFilter] = [] unless @filterCollection[shFilter]?
        HelperService.isRowSelected(item, @filterCollection[shFilter], key)

      @collectionNavbarClearSelection = (shFilter, key = null) ->
        @filterCollection[shFilter] = [] unless @filterCollection[shFilter]?
        HelperService.clearRowSelection(@filterCollection[shFilter])
        @filterInCollection(shFilter, key)

      @collectionNavbarFilterIsSelectionEmpty = (shFilter, key = null) ->
        @filterCollection[shFilter] = [] unless @filterCollection[shFilter]?
        HelperService.isRowSelectionEmpty(@filterCollection[shFilter])


      # =========================================================================
      # Helpers
      # =========================================================================

      @toggleFilterRegion = ->
        @filterRegion.visible = !@filterRegion.visible

      @resetFilter = () ->
        @filterParams = {}
        @filterLabel = {}

        # Clear filter-collections
        for k, v of @filterCollection
          HelperService.clearRowSelection(@filterCollection[k])

        @refreshGrid()

      # Return true if there's no filter
      @isNoFilter = () ->
        $.isEmptyObject @filterParams
  ]


]
