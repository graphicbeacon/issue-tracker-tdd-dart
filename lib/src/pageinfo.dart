part of issuelib;

class PageInfo {
    int skipCount;
    int pageSize;

    PageInfo();
    PageInfo.create(this.skipCount, this.pageSize);

    bool operator ==(o) {
        return o is PageInfo
                && skipCount == o.skipCount
                && pageSize == o.pageSize;
    }
}
