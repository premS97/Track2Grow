import { LightningElement, track, api, wire } from 'lwc';
import Track2GrowI from '@salesforce/resourceUrl/Track2GrowI';
import getFilterDetail from '@salesforce/apex/FilterDetailController.getFilterDetail';
import getSearchFilterDetail from '@salesforce/apex/FilterDetailController.getSearchFilterDetail';
// import scheduleClass from '@salesforce/apex/SAPOrdersSchedule.scheduleClass';
import getFilterDetailFromName from '@salesforce/apex/FilterDetailController.getFilterDetailFromName';
import deleteFilter from '@salesforce/apex/FilterDetailController.deleteFilter';
import getDetail from '@salesforce/apex/FilterDetailController.getDetail';
import getLeadByStatus from '@salesforce/apex/averagetimechartcontroller.getLeadByStatus';
import w3webResource from '@salesforce/resourceUrl/Giffile';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
export default class Track2Grow_Dashboard extends LightningElement {
    @track isCreateFilterClick = false;
    @track isConfigClick = false;
    @track isDataFilter = false;
    @track isManagePackage = false;
    @track spin = false;
    @track isLoadMessage = true;
    @track isLoad = false;
    @track isSelect = true;
    @track isSearch = false;
    @track noDataFound = false;
    @track clickedButtonLabelCheck = false;

    @track dummyDatas;
    @track saveFilterId;
    @track clickedButtonLabel;
    @track selectedFilterName;
    @track jobStatus;
    @track dataSet;
    @track picklistVal;

    @track datas = [];
    @track chartAmtData = [];
    @track chartLabel = [];
    @track chartAmtData = [];
    @track chartLabel = [];
    @track filterDetailVal = [];
    @track chartAmtData = [];
    @track chartLabel = [];

    @track selectedOption = 'bar';
    @track TrackingBasedOnAverageTimeZonePickval = 'In Minutes';
    @track selectedOption = 'bar';

    @api chartConfiguration;
    @api chartjsInitialized = false;
    @api checkRendredChild = false;
    @api checkRendred = false;

    isLeftMenu = true;
    isChartShow = false;
    isViewMore = false;
    isShowAllData = false;

    searchDatas;
    searchVal = '';
    cardTitle = '';
    message = '';

    filterViewTitle = 'View More';
    filterViewIcon = 'utility:chevrondown';
    Logo = Track2GrowI + '/Track2Grow_Save1/1.png';
    createFilterIcon = Track2GrowI + '/Track2Grow_Save1/MaskGroup5.png';
    rightArrowIcon = Track2GrowI + '/Track2Grow_Save1/ionic-ios-arrow-back.png';
    configurationIcon = Track2GrowI + '/Track2Grow_Save1/configuration.png';
    logOutIcon = Track2GrowI + '/Track2Grow_Save1/Group2993.png';
    backIcon = Track2GrowI + '/Track2Grow_Save1/Layer_2.png';
    w3webSlider1 = w3webResource;

    @wire(getFilterDetail) filterList(result) {
        if (result) {
            var dataLength = 0;
            this.dummyDatas = result;
            var conts;
            let obj = [];
            this.isManagePackage = false;
            this.selectedFilterName = '';
            if (this.dummyDatas.data != undefined) {
                dataLength = this.dummyDatas.length;
                if (this.dummyDatas.data.length > 0) {
                    conts = this.dummyDatas.data;
                    var k = '';

                    for (var key in this.dummyDatas.data[0]) {
                        k += key + ',';
                    }

                    var term = 'Track2Grow__';
                    if (k.includes(term) == true) {
                        this.isManagePackage = true;
                        this.selectedFilterName = this.dummyDatas.data[0].Track2Grow__Filter_Name__c;
                    }
                    else {
                        this.isManagePackage = false;
                        this.selectedFilterName = this.dummyDatas.data[0].Filter_Name__c;
                    }
                    this.saveFilterId = this.dummyDatas.data[0].Id;
                    this.cardTitle = 'Filter Details >>>' + this.selectedFilterName;
                    getDetail({ name: this.selectedFilterName })
                        .then((data) => {
                            this.filterDetailVal = data;
                        });
                    if (dataLength <= 3) {
                        for (var key in conts) {
                            if (key == 0) {
                                obj.push({ ...conts[key], isFilterSelect: true });
                            }
                            else {
                                obj.push({ ...conts[key], isFilterSelect: false });
                            }
                        }
                    }
                    else {
                        for (var key in conts) {
                            if (key == 0) {
                                obj.push({ ...conts[key], isFilterSelect: true });
                            }
                            else if (key >= 3) {
                                if (this.isViewMore == false) {
                                    this.isViewMore = true;
                                }
                            }
                            else {
                                obj.push({ ...conts[key], isFilterSelect: false });
                                this.isViewMore = false;
                            }
                        }
                    }
                    this.datas = obj;
                    this.getfDetail();
                }
            }
        }
    }

    getfDetail() {
        if (this.datas.length >= 1) {
            this.isDataFilter = true;
            this.isConfigClick = false;
            this.isCreateFilterClick = false;
            this.isSelect = true;
            this.isChartShow = true;
            this.isLoad = false;
            this.isLoadMessage = false;
            this.spin = false;
            this.ChartTrackingBasedOnAverageTime();
        }
        else {
            this.isSelect = false;
            this.isChartShow = false;
            this.isLoad = false;
            this.spin = false;
            this.isLoadMessage = true;
            this.clickedButtonLabelCheck = false;
            this.isCreateFilterClick = false;
        }
    }

    onViewMore() {
        if (this.isShowAllData == false) {
            this.isShowAllData = true;
            this.filterViewTitle = 'View Less';
            this.filterViewIcon = 'utility:chevronup'
            this.getFilterDetails();
        }
        else {
            this.isShowAllData = false;
            this.filterViewTitle = 'View More';
            this.isViewMore = true;
            this.filterViewIcon = 'utility:chevrondown';
            this.getFilterDetailViewLess();
        }
    }

    getFilterDetails() {
        var conts;
        let obj = [];
        var dataLength = 0;
        getFilterDetail()
            .then(data => {
                if (data != undefined) {
                    dataLength = data.length;
                    conts = data;
                    var k = '';

                    for (var key in data[0]) {
                        k += key + ',';
                    }

                    var term = 'Track2Grow__';
                    if (k.includes(term) == true) {
                        this.isManagePackage = true;
                        this.selectedFilterName = this.dummyDatas.data[0].Track2Grow__Filter_Name__c;
                    }
                    else {
                        this.isManagePackage = false;
                        this.selectedFilterName = this.dummyDatas.data[0].Filter_Name__c;
                    }
                    this.saveFilterId = this.dummyDatas.data[0].Id;
                    this.cardTitle = 'Filter Details >>>' + this.selectedFilterName;
                    if (dataLength <= 3) {
                        for (var key in conts) {
                            if (key == 0) {
                                obj.push({ ...conts[key], isFilterSelect: true });
                            }
                            else {
                                obj.push({ ...conts[key], isFilterSelect: false });
                            }
                        }
                    }
                    else {
                        for (var key in conts) {
                            if (key == 0) {
                                obj.push({ ...conts[key], isFilterSelect: true });
                            }
                            else if (key > 2) {
                                if (this.filterViewTitle == 'View Less') {
                                    obj.push({ ...conts[key], isFilterSelect: false });
                                }
                            }
                            else {
                                obj.push({ ...conts[key], isFilterSelect: false });
                                this.isViewMore = false;
                            }
                        }
                    }
                    this.datas = obj;
                }
            })
    }

    getFilterDetailViewLess() {
        var conts;
        let obj = [];
        var dataLength = 0;
        getFilterDetail()
            .then(data => {
                if (data != undefined) {
                    dataLength = data.length;
                    conts = data;
                    if (dataLength <= 3) {
                        for (var key in conts) {
                            if (key == 0) {
                                obj.push({ ...conts[key], isFilterSelect: true });
                            }
                            else {
                                obj.push({ ...conts[key], isFilterSelect: false });
                            }
                        }
                    }
                    else {
                        for (var key in conts) {
                            if (key == 0) {
                                obj.push({ ...conts[key], isFilterSelect: true });
                            }
                            else if (key > 2) {
                                if (this.isViewMore == false) {
                                    this.isViewMore = true;
                                }

                            }
                            else {
                                obj.push({ ...conts[key], isFilterSelect: false });
                                this.isViewMore = false;
                            }
                        }
                    }
                    this.datas = obj;
                }
            })
    }

    onSavedFilterClick() {
        this.isDataFilter = true;
        this.isConfigClick = false;
        this.isCreateFilterClick = false;
    }

    onHideSavedFilterClick() {
        this.isDataFilter = false;
        this.isConfigClick = false;
        this.isCreateFilterClick = false;
        this.isSelect = false;
        this.isLoadMessage = true;
        this.isLoad = false;
        this.searchVal = '';
    }

    onCreateFilterClick() {
        this.isCreateFilterClick = true;
        this.isConfigClick = false;
        this.isChartShow = false;
        this.isSelect = false;
        this.isLoad = false;
        this.isDataFilter = false;
        this.isLoadMessage = false;
        this.isCreateFilterClick = true;
    }

    onBatchCmp(event) {
        var dataId;
        this.isShowAllData = false;
        this.isChartShow = true;
        this.isSelect = true;
        this.spin = false;
        this.isLeftMenu = false;
        this.clickedButtonLabelCheck = true;
        var filtId;
        var k = '';
        filtId = event.detail.recId;
        const obj1 = event.detail.filterValDetail[0];
        for (var key in obj1) {
            k += key + ',';
        }
        var term = 'Track2Grow__';
        if (k.includes(term) == true) {
            this.isManagePackage = true;
        }
        else {
            this.isManagePackage = false;
        }
        this.filterDetailVal = event.detail.filterValDetail;
        if (this.isManagePackage) {
            this.selectedFilterName = event.detail.filterValDetail[0].Track2Grow__Filter_Name__c;
        }
        else {
            this.selectedFilterName = event.detail.filterValDetail[0].Filter_Name__c;
        }
        this.saveFilterId = filtId;
        if (this.selectedFilterName != null || this.selectedFilterName != undefined) {
            this.cardTitle = 'Filter Details >>>' + this.selectedFilterName;
        }
        else {
            this.cardTitle = 'Filter Details >>>';
        }
    }

    onCloseCreateFilter(event) {
        this.isCreateFilterClick = false;
        this.isLoad = true;
        this.spin = true;
        this.isLoadMessage = true;
        refreshApex(this.dummyDatas);
    }

    closeCreateFilters(event) {
        this.isCreateFilterClick = false;
        this.isLoad = false;
        this.isLoadMessage = true;
        refreshApex(this.dummyDatas);
    }

    onFilterDetail(event) {
        if (this.selectedFilterName != event.currentTarget.dataset.id) {
            this.clickedButtonLabelCheck = false;
        }
        this.selectedFilterName = event.currentTarget.dataset.id;
        this.cardTitle = "Filter Detail > " + event.currentTarget.dataset.id;
        this.isSelect = true;
        this.isLeftMenu = false;
        this.isChartShow = true;
        this.isLoad = false;
        this.datas.map(val => {
            if (this.isManagePackage) {
                if (val.Track2Grow__Filter_Name__c == this.selectedFilterName) {
                    val.isFilterSelect = true;
                }
                else {
                    val.isFilterSelect = false;
                }
            }
            else {
                if (val.Filter_Name__c == this.selectedFilterName) {
                    val.isFilterSelect = true;
                }
                else {
                    val.isFilterSelect = false;
                }
            }
        })
        refreshApex(this.dummyDatas);
        getDetail({ name: this.selectedFilterName })
            .then((data) => {
                this.filterDetailVal = data;
            });
        this.ChartTrackingBasedOnAverageTime();
    }

    TrackingBasedOnAverageTimeZonePick(event) {
        this.TrackingBasedOnAverageTimeZonePickval = event.target.value;
        if (this.TrackingBasedOnAverageTimeZonePickval == 'In Minutes') {
            this.ChartTrackingBasedOnAverageTime();
        }
        else if (this.TrackingBasedOnAverageTimeZonePickval == 'In Hours') {
            this.ChartTrackingBasedOnAverageTime();
        }
        else if (this.TrackingBasedOnAverageTimeZonePickval == 'In Days') {
            this.ChartTrackingBasedOnAverageTime();
        }
    }

    ChartTrackingBasedOnAverageTime() {
        getFilterDetailFromName({ filterName: this.selectedFilterName, timezone: this.TrackingBasedOnAverageTimeZonePickval })
            .then(data => {
                this.chartLabel = [];
                this.chartAmtData = [];
                if (data) {
                    for (let key in data) {
                        this.chartLabel.push(key);
                        this.chartAmtData.push(data[key]);
                    }
                    this.chartConfiguration =
                    {
                        type: this.selectedOption,
                        data: {
                            datasets: [{
                                label: 'Tracking Based On Average Time(In Minutes)',
                                backgroundColor: "green",
                                data: Object.values(data),
                            }],
                            labels: Object.keys(data),
                        },
                        options: {},
                    };
                    this.checkRendred = false;
                    this.checkRendredChild = true;
                    this.clickedButtonLabelCheck = true;
                    this.error = undefined;
                }
                else if (error) {
                    this.error = error;
                    this.record = undefined;
                }
            })
    }

    selectOptionChanveValue(event) {
        this.picklistVal = event.target.value;
        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        this.getcallby();
    }

    onSearchSaveFilter(event) {
        this.searchVal = event.target.value;
        if (event.target.value != '') {
            getSearchFilterDetail({ searchVal: this.searchVal })
                .then(data => {
                    if (data.length > 0) {
                        this.searchDatas = data;
                        this.isSearch = true;
                        this.message = "";
                        this.noDataFound = false;
                    }
                    else {
                        this.isSearch = true;
                        this.message = "No data saved with " + this.searchVal + " name";
                        this.noDataFound = true;
                    }
                })
        }
        else {
            this.isSearch = false;
            refreshApex(this.dummyDatas);
        }
    }

    getcallby() {
        getLeadByStatus({ status: this.picklistVal, objectVal: this.objectVal, Field: this.objectField, recordTypes: this.selectedVal1, businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave, selectedName: this.selectedFilterName })
            .then(data => {
                if (data) {
                    this.dataSet = data;
                    this.Initializechartjs();
                }
                else if (result.error) {
                    return result.error;
                }
            });
    }

    detailBackClick() {
        this.isLeftMenu = true;
        this.isSelect = false;
        this.isChartShow = false;
        this.isLoad = false;
        this.spin = false;
        this.isDataFilter = false;
        this.isLoadMessage = true;
        this.clickedButtonLabelCheck = false;
        this.isCreateFilterClick = false;
        refreshApex(this.dummyDatas);
    }

    // handle delete
    handleDeleteFilter(event) {
        const filterName = event.currentTarget.dataset.id;
        this.selectedFilterName = '';
        this.clickedButtonLabelCheck = false;
        this.filterDetailVal = '';
        deleteFilter({ filterName: filterName })
            .then(() => {
                this.isViewMore = false;
                this.isShowAllData = false;
                refreshApex(this.dummyDatas);
                this.isSelect = false;
                this.isLoad = false;
                this.isLoadMessage = true;
                this.clickedButtonLabelCheck = false;
                const event = new ShowToastEvent({
                    title: 'Successfully',
                    message: 'Filter Deleted Successfully',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            })
            .catch(() => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'Error in Deleting Record',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            })
        return refreshApex(this.dummyDatas);
    }

    renderedCallback() {
        refreshApex(this.dummyDatas);
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
            loadScript(this, ChartJS)
        ])
            .then(() => {

            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading chartJs',
                        message: error.message,
                        variant: 'error'
                    })
                );
            });
    }

    Initializechartjs() {
        if (window.bar != undefined) {
            window.bar.destroy();
        }
        var labell = [];
        var count = [];
        for (let ownerLabel in Object.values(this.dataSet)) {
            labell.push(Object.values(this.dataSet)[ownerLabel].label);
            count.push(Object.values(this.dataSet)[ownerLabel].count);
        }
        var arrayOfObj = labell.map(function (d, i) {
            return {
                label: d,
                data: count[i] || 0
            };
        });


        var sortedArrayOfObj = arrayOfObj.sort(function (a, b) {
            return a.data - b.data;
        });
        var newArrayLabel = [];
        var newArrayData = [];
        sortedArrayOfObj.forEach(function (d) {
            newArrayLabel.push(d.label);
            newArrayData.push(d.data);
        });

        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        window.bar = new Chart(ctx, {
            type: 'bar',
            data: {

                labels: newArrayLabel,
                datasets: [{
                    label: 'Average Time Spent On Owner Leader Board Per Status',
                    data: newArrayData,
                    backgroundColor: "green"
                }],
            },
            options: {

            },
        });

    }
closeConfig(){
    console.log('closeConfig called' );
    this.isCreateFilterClick = false;
        this.isLoad = false;
        this.spin = false;
        this.isLoadMessage = true;
        this.isConfigClick=false;
}
    onConfigClick(){
        this.isCreateFilterClick = false;
        this.isConfigClick = true;
        this.isChartShow = false;
        this.isSelect = false;
        this.isLoad = false;
        this.isDataFilter = false;
        this.isLoadMessage = false;
                // scheduleClass()
        // .then(()=>{
        //     const event = new ShowToastEvent({
        //                 title: 'SUCCESS',
        //                 message: 'Configuration is done for 12 AM from MON-FRI',
        //                 variant: 'SUCCESS ',
        //                 mode: 'dismissable'
        //             });
        //             this.dispatchEvent(event);
        // })
    }
}