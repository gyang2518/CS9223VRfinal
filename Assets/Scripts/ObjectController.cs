using System.Collections;
using UnityEngine;

/// <summary>
/// Controls target objects behaviour.
/// </summary>
public class ObjectController : MonoBehaviour
{
    /// <summary>
    /// The material to use when this object is inactive (not being gazed at).
    /// </summary>
    // public Material InactiveMaterial;

    /// <summary>
    /// The material to use when this object is active (gazed at).
    /// </summary>
    // public Material GazedAtMaterial;

    public bool gazedAt;

    /// <summary>
    /// Start is called before the first frame update.
    /// </summary>
    public void Start()
    {
        gazedAt = false;
    }

        private void Update()
    {
        if (gazedAt){
            roation();
        }
    }

    public void translation()
    {
        Vector3 newPos = new Vector3(0,5,0);
        transform.localPosition = newPos;
    }

    public void roation()
    {
        transform.RotateAround(transform.position, transform.up, Time.deltaTime * 90f);
    }

    /// <summary>
    /// This method is called by the Main Camera when it starts gazing at this GameObject.
    /// </summary>
    public void OnPointerEnter()
    {
        gazedAt = true ;
    }

    /// <summary>
    /// This method is called by the Main Camera when it stops gazing at this GameObject.
    /// </summary>
    public void OnPointerExit()
    {
        gazedAt = false;
    }

    /// <summary>
    /// This method is called by the Main Camera when it is gazing at this GameObject and the screen
    /// is touched.
    /// </summary>
    public void OnPointerClick()
    {
        translation();
    }


}
