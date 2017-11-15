using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamController : MonoBehaviour {
    
    private List<GameObject> Lights;

    private void Start()
    {
        //Lights.Add(GameObject.FindGameObjectWithTag("Agent"));
    }

    void OnPreCull()
    {
        //foreach (GameObject light in Lights)
        //{
        //    light.GetComponentInChildren<Light>().enabled = false;
        //}
    }

    void OnPostRender()
    {
        //foreach (GameObject light in Lights)
        //{
        //    light.GetComponentInChildren<Light>().enabled = true;
        //}
    }
}
