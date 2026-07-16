Class HoleFoods.Interop.BO.SyncCube Extends Ens.BusinessOperation
{
    Method OnMessage(pInput As Ens.Request) As %Status
    {
        Set sc = $$$OK
        
        set sc = ##class(%DeepSee.Utils).%SynchronizeCube("HoleFoodsSales", 1, .facts)

        Return sc
    }

}
